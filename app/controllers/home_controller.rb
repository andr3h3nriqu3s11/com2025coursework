class HomeController < ApplicationController

  def home
    #if the user is signed in there is no point in seeing this page and they should see the dashboard page
    if user_signed_in?
      redirect_to dashboard_path
    end

    #Set up some dummy wallets so that it can be used by the render function to show some nice wallet icons
    @wallet = Wallet.new
    @wallet.name = "This is a wallet"
    @wallet.wallet_icon = WalletIcon.from_str("wallet")

    puts @wallet.wallet_icon.icon
    puts @wallet.wallet_icon

    @walletIn = Wallet.new
    @walletIn.wallet_icon = WalletIcon.from_str("wallet")
    @walletIn.name = "In"

    @walletOut = Wallet.new
    @walletOut.wallet_icon = WalletIcon.from_str("wallet")
    @walletOut.name = "Out"

  end

end
