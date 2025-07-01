# frozen_string_literal: true

class ProcessTransactionService
  def self.call(record, wallet)
    new(record, wallet:).call
  end

  attr_reader :record, :wallet

  delegate :to_address, :to_amount_cents, :network_fee_cents, to: :record

  def initialize(record, wallet:)
    @record = record
    @wallet = wallet
  end

  def call
    send_amount
  end

  private

  def send_amount
    Rails.logger.info("Sending #{to_amount_cents} to #{to_address} (fee=#{network_fee_cents})")
    wallet.build_tx(to_address, to_amount_cents, network_fee_cents)
  end
end
