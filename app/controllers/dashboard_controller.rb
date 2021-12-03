class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :get_wallets
  before_action :get_transactions
  before_action :get_quicklinks

  def dashboard
  end

  def get_quicklinks
    #Gets all the quick links
    @quicklinks = QuickLink.by_user(current_user)
  end

  def get_wallets
    #Gets all the wallets related to his user
    @wallets = Wallet.by_user(current_user)
  end

  def get_transactions
    # Gets the first 21 transactions related to this number if the number reached above 20 then there
    # will be a link to another page so that the dashboard does not get full of transactions
    @transactions = Transaction.by_user(current_user).take(21)
  end

end
