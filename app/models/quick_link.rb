class QuickLink < ApplicationRecord

  belongs_to :origin, class_name: 'Wallet'
  belongs_to :destination, class_name: 'Wallet'
  validates_presence_of :origin, :destination, :name

  scope :by_user, -> (user) { by_user_id(user.id) }
  scope :by_user_id, -> (user_id) {
    joins("INNER JOIN wallets ON wallets.id = origin_id OR wallets.id = destination_id").
      where(["wallets.user_id = ?", user_id]).
      group("id")
  }

  scope :by_wallet, -> (wallet) { by_wallet_id(wallet.id) }
  scope :by_wallet_id, -> (wallet_id) {
    where(["origin_id = ? OR destination_id = ?", wallet_id, wallet_id]).
      group("id")
  }

  scope :create_default_quicklinks, -> (user_id) do
    names = [ I18n.t("quick_links.default.receive"), I18n.t("quick_links.default.expenses")]
    userWallets = Wallet.by_user_id(user_id)
    destination = [ userWallets.by_name(I18n.t("wallet.default.net-worth")).first!, userWallets.by_name(I18n.t("wallet.default.expenses")).first! ]
    origin = [userWallets.by_name(I18n.t("wallet.default.incomings")).first!, userWallets.by_name(I18n.t("wallet.default.net-worth")).first! ]
    names.each_with_index do |name, i|
      q = QuickLink.new
      q.origin = origin[i]
      q.destination = destination[i]
      q.name = name
      q.save
    end

  end

end
