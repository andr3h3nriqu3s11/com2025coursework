class Wallet < ApplicationRecord
  belongs_to :user
  #Name is only unique for each user id
  validates :name, uniqueness: { scope: :user_id }
  validates :name, :user_id, :presence => true

  scope :by_user_id, -> (user_id) { where(['user_id = ?', user_id]) }
  scope :by_user, -> (user) { by_user_id(user.id) }

  # Creates and saves the default wallets for a user
  scope :create_default_wallets, -> (user_id) do
    names = [ I18n.t("wallet.default.name1"), I18n.t("wallet.default.name2")]
    names.each do |name|
      w = Wallet.new
      w.name = name
      w.system = true
      w.user_id = user_id
      w.save
    end
  end

end
