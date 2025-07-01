# frozen_string_literal: true

class RecalculateForm < BaseForm
  attr_reader :record
  alias object record

  def initialize(amount)
    @record = Transaction.new(
      from_amount: amount,
      to_amount_currency: "BTC"
    )
  end

  def recalculate!
    ExchangeService.apply_fees!(record)
  end
end
