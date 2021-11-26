class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :get_wallets
  before_action :get_transactions

  def dashboard
  end

  def get_wallets
    @wallets = Wallet.by_user(current_user)
  end

  def get_transactions
    @transactions = Transaction.by_user(current_user).take(21)
  end

end
