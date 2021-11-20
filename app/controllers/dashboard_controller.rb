class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :get_wallets

  def dashboard
  end

  def get_wallets
    @wallets = Wallet.by_user(current_user)
  end

end
