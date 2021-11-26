class Transaction < ApplicationRecord
  belongs_to :origin, class_name: 'Wallet'
  belongs_to :destination, class_name: 'Wallet'
  validates_presence_of :origin, :destination, :value

  # scope :by_wallet, (wallet_id) { where["origin_id = ? OR destination_id = ?", wallet_id, wallet_id] }
  #
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

end
