class Trasanction < ApplicationRecord
  belongs_to :origin, class_name: 'Wallet'
  belongs_to :destination, class_name: 'Wallet'
  validates_presence_of :origin, :destination, :value

end
