class ExchangeRateService
  def self.call(from_iso, to_iso)
    Rails.cache.fetch([ Date.today, from_iso, to_iso ], expires_in: 1.day) do
      new.call(from_iso, to_iso)
    end
  end

  def call(from_iso, to_iso)
    dat = JSON.parse(
      RestClient.get("https://mempool.space/api/v1/prices")
    )

    if from_iso == "BTC"
      Money.new(100 * dat[to_iso], "USD").round
    elsif to_iso == "BTC"
      Money.new(10**8 / dat[from_iso], "BTC").round
    else
      raise ArgumentError, "Unsupported currencies"
    end
  end
end
