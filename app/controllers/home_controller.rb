class HomeController < ApplicationController

  def home
    #if the user is signed in there is no point in seeing this page and they should see the dashboard page
    if user_signed_in?
      redirect_to dashboard_path
    end

    #Set up some dummy wallets so that it can be used by the render function to show some nice wallet icons
    @wallet = Wallet.new
    @wallet.name = I18n.t("home.home.wallets.this_is_wallet")
    @wallet.wallet_icon = WalletIcon.from_str("wallet")


    @walletIn = Wallet.new
    @walletIn.wallet_icon = WalletIcon.from_str("wallet")
    @walletIn.name = I18n.t("home.home.wallets.in")

    @walletOut = Wallet.new
    @walletOut.wallet_icon = WalletIcon.from_str("wallet")
    @walletOut.name = I18n.t("home.home.wallets.out")

  end

end
