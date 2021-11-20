require 'test_helper'

class WalletTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #
  #
  #

  test "Should not create no user_id, no name" do
    wallet = Wallet.new
    refute wallet.save
  end

  test "Should not create no no name" do
    wallet = Wallet.new
    wallet.user_id = User.first.id
    refute wallet.save
  end

  test "Should not create no user_id" do
    wallet = Wallet.new
    wallet.name = "Name"
    refute wallet.save
  end

  test "Should not create invalid user_id" do
    wallet = Wallet.new
    wallet.name = "Name"
    wallet.user_id = User.last.id + 1
    refute wallet.save
  end

  test "Should create" do
    wallet = Wallet.new
    wallet.name = "Name"
    wallet.user_id = User.last.id
    assert wallet.save
  end

end
