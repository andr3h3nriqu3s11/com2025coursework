# There is no route/controller for this model since this is supposed to be a static model
# for the app to run please tun rails db:seed to fill this model with the correct values
class WalletIcon < ApplicationRecord

  has_many :wallets

  validates_presence_of :icon

  scope :from_str, -> (str) { where(["icon = ?", str]).first! }

end
