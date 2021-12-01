require 'test_helper'

class WalletTest < ActiveSupport::TestCase

  setup do
    @user = users(:one)
    @user1 = users(:two)

    @icon = wallet_icons(:one)
  end

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
    wallet.user_id = -1
    refute wallet.save
  end

  test "Should not create invalid wallet_icon_id" do
    wallet = Wallet.new
    wallet.name = "Name"
    wallet.user_id = @user.id
    wallet.wallet_icon_id = -1
    refute wallet.save
  end

  test "Should create" do
    wallet = Wallet.new
    wallet.name = "Name"
    wallet.user_id = @user.id
    wallet.wallet_icon = @icon
    assert wallet.save
  end

  test "Should not create 2 with the same name for the same user" do
    wallet = Wallet.new
    wallet.name = "Name"
    wallet.user_id = @user.id
    wallet.wallet_icon = @icon
    assert wallet.save

    wallet1 = Wallet.new
    wallet1.name = "Name"
    wallet1.user_id = @user.id
    wallet.wallet_icon = @icon
    refute wallet1.save
  end

  test "Should create 2 with the same name for different users" do
    wallet = Wallet.new
    wallet.name = "Name"
    wallet.user_id = @user.id
    wallet.wallet_icon = @icon
    assert wallet.save

    wallet1 = Wallet.new
    wallet1.name = "Name"
    wallet1.user_id = @user1.id
    wallet1.wallet_icon = @icon
    assert wallet1.save
  end

end
