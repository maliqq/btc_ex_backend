# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token

      protected

      def authenticate_user!
        # :no-op:
      end

      def current_user
        # :no-op:
        # TODO add devise later
      end
    end
  end
end
