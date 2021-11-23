class Transaction < ApplicationRecord
  belongs_to :origin, class_name: 'Wallet'
  belongs_to :destination, class_name: 'Wallet'
  validates_presence_of :origin, :destination, :value

  # scope :by_wallet, (wallet_id) { where["origin_id = ? OR destination_id = ?", wallet_id, wallet_id] }

end
