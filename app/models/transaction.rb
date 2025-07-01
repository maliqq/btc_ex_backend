# frozen_string_literal: true

StateMachines::Machine.ignore_method_conflicts = true

class Transaction < ApplicationRecord
  # FIXME: move to settings
  DEFAULT_NETWORK_FEE = 600 # satoshis
  DEFAULT_MAX_AMOUNT = 3000 # 30 USDT
  DEFAULT_EXCHANGE_FEE_RATE = 0.03 # 3%

  # before_validation :apply_defaults!

  def apply_defaults!
    self.exchange_rate ||= ExchangeRateService.call("USD", "BTC")
    self.network_fee_cents ||= DEFAULT_NETWORK_FEE
    self.exchange_fee_rate ||= DEFAULT_EXCHANGE_FEE_RATE
  end

  VALID_ADDRESS_TYPES = %w[pubkey_hash script_hash witness_v0_keyhash].freeze

  monetize :from_amount_cents, with_currency: "USDT"
  monetize :to_amount_cents, with_currency: "BTC"
  monetize :exchange_fee_cents, with_currency: "BTC"
  monetize :network_fee_cents, with_currency: "BTC"

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :from_amount_cents, presence: true, numericality: { more_than: 0, less_than_or_equal: DEFAULT_MAX_AMOUNT }

  attr_accessor :terms_accepted

  validates :terms_accepted, acceptance: true
  validate :validate_to_address

  def decorate
    TransactionDecorator.new(self)
  end

  def validate_to_address
    script = begin
      Bitcoin::Script.parse_from_addr(to_address)
    rescue StandardError
      nil
    end
    return if script&.type.in? VALID_ADDRESS_TYPES

    errors.add(:to_address, "Should be valid P2PKH, P2SH, or P2WPKH")
  end

  enum :status, { pending: "pending", success: "success", failed: "failed" }
  state_machine :status, initial: :pending do
    state :success
    state :failed

    event :broadcasted do
      transition pending: :success
    end

    event :broadcast_failed do
      transition pending: :failed
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    %i[email]
  end
end
