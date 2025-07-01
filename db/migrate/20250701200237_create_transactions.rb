# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_enum :status_type, %i[pending failed success]

    create_table :transactions do |t|
      t.string :email

      t.monetize :from_amount, currency: { null: true, default: nil }
      t.monetize :to_amount,
                 amount: { null: true, default: nil },
                 currency: { null: true, default: nil }
      t.monetize :exchange_fee,
                 amount: { null: true, default: nil },
                 currency: { null: true, default: nil }
      t.monetize :network_fee,
                 amount: { null: true, default: nil },
                 currency: { null: true, default: nil }

      t.string :txid, null: false
      t.string :from_address, null: false
      t.string :to_address, null: false

      t.decimal :exchange_rate
      t.decimal :exchange_fee_rate

      t.enum :status, enum_type: :status_type, default: :pending

      t.timestamp :processed_at
      t.timestamps
    end
  end
end
