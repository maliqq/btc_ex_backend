# frozen_string_literal: true

class WalletService
  def self.wallet
    @wallet ||= BtcWallet::Wallet.load_default!(
      logger: Rails.logger
    )
  end
end
