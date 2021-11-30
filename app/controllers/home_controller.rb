class HomeController < ApplicationController

  def home
    if user_signed_in?
      redirect_to dashboard_path
    end

    @wallet = Wallet.new
    @wallet.name = "This is a wallet"

    @walletIn = Wallet.new
    @walletIn.name = "In"

    @walletOut = Wallet.new
    @walletOut.name = "Out"

  end

end
