# frozen_string_literal: true

ActiveAdmin.register Transaction do
  index do
    id_column
    column :created_at
    column :email
    column :txid
    column :from_amount do |tx|
      tx.decorate.from_amount_str
    end
    column :to_amount do |tx|
      tx.decorate.to_amount_str
    end
    column :exchange_rate
    column :exchange_fee
    column :status
  end

  filter :email
end
