require 'test_helper'

class WalletsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    @wallet = wallets(:one)
    @user = users(:one)
    @user2 = users(:two)
  end

  # test "should get index" do
  #   get wallets_url
  #   assert_response :success
  # end
  #
  # test "should get new" do
  #   get new_wallet_url
  #   assert_response :success
  # end
  #
  # test "should create wallet" do
  #   assert_difference('Wallet.count') do
  #     post wallets_url, params: { wallet: { icon: @wallet.icon, name: @wallet.name, owner: @wallet.owner, system: @wallet.system, value: @wallet.value } }
  #   end
  #
  #   assert_redirected_to wallet_url(Wallet.last)
  # end

  test "should show wallet" do
    sign_in @user
    get wallet_url(@wallet)
    assert_response :success
    sign_out @user
  end

  test "should show wallet wrong user" do
    sign_in @user2
    get wallet_url(@wallet)
    assert_response :redirect
    sign_out @user2
  end

  test "should not show wallet - not exists" do
    sign_in @user
    get wallet_url(-1)
    assert_response :redirect
    sign_out @user
  end

  test "should not show wallet - not login" do
    get wallet_url(-1)
    assert_response :redirect
  end

  test "should not get wallet404 - not login" do
    get wallet404_path
    assert_response :redirect
  end

  test "should get wallet404" do
    sign_in @user
    get wallet404_path
    assert_response :success
    sign_out @user
  end

  # test "should get edit" do
  #   get edit_wallet_url(@wallet)
  #   assert_response :success
  # end
  #
  # test "should update wallet" do
  #   patch wallet_url(@wallet), params: { wallet: { icon: @wallet.icon, name: @wallet.name, owner: @wallet.owner, system: @wallet.system, value: @wallet.value } }
  #   assert_redirected_to wallet_url(@wallet)
  # end
  #
  # test "should destroy wallet" do
  #   assert_difference('Wallet.count', -1) do
  #     delete wallet_url(@wallet)
  #   end
  #
  #   assert_redirected_to wallets_url
  # end
end
