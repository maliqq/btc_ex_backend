# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < BaseController
      TX_PARAMS = %i[from_amount from_amount_currency to_amount_currency to_address email terms_accepted].freeze
      TX_PROPS = {
        only: %i[
          id
          exchange_rate
          exchange_fee_rate
          to_address
        ],
        methods: %i[
          from_amount
          to_amount
          exchange_fee
          network_fee
        ]
      }.freeze

      def create
        @form = ExchangeForm.new

        if @form.save(tx_params)
          render json: @form.decorated_object.as_json(TX_PROPS)
        else
          render json: { errors: @form.errors }, status: :unprocessable_entity
        end
      end

      def recalculate
        @form = RecalculateForm.new(params[:amount])
        @form.recalculate!

        render json: @form.decorated_object.as_json(TX_PROPS)
      end

      def show
        render json: Transaction.find(params[:id]).decorate.as_json(TX_PROPS)
      end

      private

      def tx_params
        params.require(:transaction).permit(TX_PARAMS)
      end
    end
  end
end
