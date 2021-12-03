class Wallet < ApplicationRecord

  has_many :transactions
  has_many :quick_links

  # Weird form a "logic" standpoint but it's the way to do many to one relation ships on rails
  belongs_to :wallet_icon

  belongs_to :user
  #Name is only unique for each user id
  validates :name, uniqueness: { scope: :user_id }
  validates :name, :user_id, :presence => true

  scope :by_user_id, -> (user_id) { where(['user_id = ?', user_id]) }
  scope :by_user, -> (user) { by_user_id(user.id) }
  scope :by_id, -> (id) { where(['id = ?', id]) }

  scope :by_name, -> (name) { where(['name = ?', name])}

  #Updates the value of a wallets
  scope :update_value, -> (wallet) {
    #Get transactions where this is the origin
    transactions_origin = Transaction.where(["origin_id = ?",  wallet.id])

    #Get transactions where this is the destination
    transactions_destination = Transaction.where(["destination_id = ?",  wallet.id])

    value = 0

    transactions_destination.each { |t| value += t.value }
    transactions_origin.each { |t| value -= t.value }

    wallet.value = value

    wallet.save
  }

  scope :update_value_id, -> (wallet_id) { update_value_id(by_id(wallet_id)) }


  # Creates and saves the default wallets for a user
  scope :create_default_wallets, -> (user_id) do
    names = [ I18n.t("wallet.default.expenses"), I18n.t("wallet.default.incomings"), I18n.t("wallet.default.net-worth")]
    icons = [ "currency-dollar", "box-arrow-in-left", "wallet2"]
    names.each_with_index do |name, i|
      w = Wallet.new
      w.name = name
      w.system = true
      w.user_id = user_id
      w.wallet_icon = WalletIcon.from_str(icons[i])
      w.save
    end
  end

end
