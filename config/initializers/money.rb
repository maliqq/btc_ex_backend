# frozen_string_literal: true

Money::Currency.register(
  iso_code: 'USDT',
  name: 'Tether',
  symbol: '₮',
  subunit_to_unit: 100,
  exponent: 2
)
