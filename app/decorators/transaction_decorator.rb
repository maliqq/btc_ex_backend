# frozen_string_literal: true

class TransactionDecorator < SimpleDelegator
  def from_amount_exchanged
    bank = Money::Bank::VariableExchange.new
    bank.add_rate("USDT", "BTC", exchange_rate)

    bank.exchange_with(__getobj__.from_amount, to_amount_currency)
  end

  def from_amount_str
    from_amount.format with_currency: true, symbol: false
  end

  def to_amount_str
    to_amount.format with_currency: true, symbol: false
  end

  def exchange_fee_str
    exchange_fee.format with_currency: true, symbol: false
  end

  def network_fee_str
    network_fee.format with_currency: true, symbol: false
  end

  def as_json(*)
    super.merge(
      from_amount_str:,
      to_amount_str:,
      exchange_fee_str:,
      network_fee_str:
    )
  end
end
