class HomeController < ApplicationController

  def home
    if user_signed_in?
      redirect_to dashboard_path
    end

    @wallet = Wallet.new
    @wallet.name = "This is a wallet"

  end

end
