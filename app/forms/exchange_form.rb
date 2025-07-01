# frozen_string_literal: true

require "btc_wallet"

class ExchangeForm < BaseForm
  attr_reader :record
  alias object record

  def initialize(**args)
    super
    @record = Transaction.new(**args)
  end

  def save(params)
    record.assign_attributes(params)
    ExchangeService.apply_fees!(record)

    if record.valid?
      ActiveRecord::Base.transaction do
        tx = process_transaction
        broadcast_transaction(tx) # ideally put into background job
      end
    else
      errors.merge! record.errors
    end

    valid?
  end

  private

  def process_transaction
    wallet = WalletService.wallet
    tx = ProcessTransactionService.call(record, wallet)

    record.txid = tx.txid
    record.from_address = wallet.address
    record.save!

    tx
  end

  def broadcast_transaction(tx)
    BroadcastService.call(tx)
    record.broadcasted!
  rescue StandardError => e
    record.broadcast_failed!
  end

  def valid?
    record.valid? && errors.empty?
  end
end
