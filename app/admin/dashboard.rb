# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "System Wallet" do
          dl do
            dt "BTC Address"
            dd do
              code WalletService.wallet.address
            end

            dt "BTC Balance"
            dd do
              h1 Money.new(WalletService.wallet.balance, "BTC").format
            end
          end
        end
      end

      column do
        panel "Statistics" do
          dl do
            dt "Total exchange fee"
            dd do
              h1 Money.new(Transaction.success.sum(:exchange_fee_cents), "BTC").format
            end

            dt "Total transactions"
            dd do
              h1 Transaction.count
            end

            dt "Total success transactions"
            dd do
              h1 Transaction.success.count
            end
          end
        end
      end

      column do
        panel "Recent Transactions" do
          dl do
            Transaction.order("id DESC").limit(5).map(&:decorate).map do |tx|
              dt do
                link_to(truncate(tx.txid), admin_transaction_path(tx)) + " (#{tx.status})"
              end

              dd do
                span("#{tx.from_amount_str} &rarr; #{tx.to_amount_str}".html_safe)
              end
            end
          end
        end
      end
    end
  end
end
