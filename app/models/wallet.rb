class Wallet < ApplicationRecord
  belongs_to :user
  #Name is only unique for each user id
  validates :name, uniqueness: { scope: :user_id }
  validates :name, :user_id, :presence => true
end
