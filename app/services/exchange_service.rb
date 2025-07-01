# frozen_string_literal: true

class ExchangeService
  def self.apply_fees!(record)
    record.apply_defaults!
    amount = record.decorate.from_amount_exchanged

    record.exchange_fee = amount * record.exchange_fee_rate
    record.to_amount = amount - record.exchange_fee - record.network_fee
  end
end
