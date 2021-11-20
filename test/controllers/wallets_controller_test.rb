require 'test_helper'

class WalletsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    @wallet = wallets(:one)
    @wallet2 = wallets(:two)
    @user = users(:one)
    @user2 = users(:two)
  end

  test "should not get index - no user" do
    get wallets_url
    assert_redirected_to new_user_session_url
  end

  test "should not get index - no permission" do
    sign_in @user
    get wallets_url
    assert_redirected_to dashboard_url
    sign_out @user
  end

  # TODO: user premissions
  # test "should get index" do
  #   get wallets_url
  #   assert_response :redirect
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

  test "should not show wallet - wrong user" do
    sign_in @user2
    get wallet_url(@wallet)
    assert_redirected_to wallet404_url
    sign_out @user2
  end

  test "should not show wallet - not exists" do
    sign_in @user
    get wallet_url(-1)
    assert_redirected_to wallet404_url
    sign_out @user
  end

  test "should not show wallet - not exists and no login" do
    get wallet_url(-1)
    assert_redirected_to new_user_session_url
  end

  test "should not get wallet404 - not login" do
    get wallet404_path
    assert_redirected_to new_user_session_url
  end

  test "should get wallet404" do
    sign_in @user
    get wallet404_path
    assert_response :success
    sign_out @user
  end

  test "should not get edit - no login" do
    get edit_wallet_url(@wallet)
    assert_redirected_to new_user_session_url
  end

  test "should not get edit - not exists and no login" do
    get edit_wallet_url(-1)
    assert_redirected_to new_user_session_url
  end

  test "should not get edit - wrong user" do
    sign_in @user2
    get edit_wallet_url(@wallet)
    assert_redirected_to wallet404_url
    sign_out @user2
  end

  test "should not get edit - not exists" do
    sign_in @user
    get edit_wallet_url(-1)
    assert_redirected_to wallet404_url
    sign_out @user
  end

  test "should get edit" do
    sign_in @user
    get edit_wallet_url(@wallet)
    assert_response :success
    sign_out @user
  end


  # test "should update wallet" do
  #   patch wallet_url(@wallet), params: { wallet: { icon: @wallet.icon, name: @wallet.name, owner: @wallet.owner, system: @wallet.system, value: @wallet.value } }
  #   assert_redirected_to wallet_url(@wallet)
  # end
  #
  test "should not destroy wallet - no user" do
    delete wallet_url(@wallet)
    assert_redirected_to new_user_session_url
  end

  test "should not destroy wallet - no user and not exists" do
    delete wallet_url(-1)
    assert_redirected_to new_user_session_url
  end

  test "should not destroy wallet - no not exists" do
    sign_in @user
    delete wallet_url(-1)
    assert_redirected_to wallet404_url
    sign_out @user
  end

  test "should not destroy wallet - wrong user" do
    sign_in @user2
    delete wallet_url(@wallet)
    assert_redirected_to wallet404_url
    sign_out @user2
  end

  test "should not destroy wallet - system wallet" do
    sign_in @user
    delete wallet_url(@wallet2)
    assert_redirected_to wallet_url(@wallet2)
    sign_out @user
  end

  test "should destroy wallet" do
    sign_in @user
    assert_difference('Wallet.count', -1) do
      delete wallet_url(@wallet)
    end
    assert_redirected_to dashboard_url
    sign_out @user
    @wallet.save

  end
end
