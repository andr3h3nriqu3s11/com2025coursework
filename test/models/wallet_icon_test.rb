require 'test_helper'

class WalletIconTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "Fail create no icon" do
    refute WalletIcon.new.save
  end

  test "Create" do
    wallet_icon = WalletIcon.new
    wallet_icon.icon = "test"
    assert wallet_icon.save
  end

  test "Fail Create duplicate" do
    wallet_icon = WalletIcon.new
    wallet_icon.icon = "test"
    assert wallet_icon.save

    assert_raise do
      wallet_icon = WalletIcon.new
      wallet_icon.icon = "test"
      wallet_icon.save
    end

  end

  test "Get name" do
    wallet_icon = WalletIcon.new
    wallet_icon.icon = "test"
    assert wallet_icon.save

    refute WalletIcon.from_str("test").nil?

    assert_raise ActiveRecord::RecordNotFound do
      WalletIcon.from_str("test11").nil?
    end
  end

end
