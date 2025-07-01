class BroadcastService
  def self.call(tx)
    WalletService.wallet.broadcast(tx)
  rescue => e
    Rails.logger.tagged(tx.txid) do
      Rails.logger.error(e)
    end
    raise e
  end
end
