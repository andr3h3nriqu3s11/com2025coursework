require 'test_helper'

class WalletsControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    @wallet = wallets(:one)
    @wallet2 = wallets(:two)
    @user = users(:one)
    @user2 = users(:two)
    @admin = users(:admin)
  end

  test "should not get index - no user" do
    get wallets_url
    assert_redirected_to new_user_session_url
  end

  test "should get index" do
    sign_in @user
    get wallets_url
    assert_response :success

    check_header_login

    #Checks that all the wallets from that user are shown
    assert_select ".walletLineItem" do |elms|
      # We remove one for the header line which has the same selector of the rest of the lines
      assert_equal Wallet.by_user(@user).length, elms.length - 1
    end


    sign_out @user
  end

  test "should get index - admin" do
    sign_in @admin
    get wallets_url
    assert_response :success

    check_header_login

    #Checks that all the wallets from that user are shown
    assert_select ".walletLineItem" do |elms|
      # We remove one for the header line which has the same selector of the rest of the lines
      assert_equal Wallet.all.length, elms.length - 1
    end


    sign_out @admin
  end

  test "should not get new - no user" do
    get new_wallet_url
    assert_redirected_to new_user_session_url
  end

  test "should get new" do
    sign_in @user

    get new_wallet_url
    assert_response :success

    check_header_login

    sign_out @user
  end

  test "should not create wallet - no login" do
    assert_difference('Wallet.count', 0) do
      post wallets_url, params: { wallet: { wallet_icon_id: @wallet.wallet_icon_id, name: @wallet.name, user_id: @user.id, system: @wallet.system, value: @wallet.value } }
    end
    assert_redirected_to new_user_session_url
  end

  test "should not create wallet - same wallet for the same user" do
    sign_in @user

    assert_difference('Wallet.count') do
      post wallets_url, params: { wallet: { wallet_icon_id: @wallet.wallet_icon_id, name: "new 1", system: @wallet.system, value: @wallet.value } }
    end

    assert_redirected_to wallet_url(Wallet.last)

    assert_difference('Wallet.count', 0) do
      # To assert :unprocessable_entity
      assert_equal(422, post(wallets_url, params: { wallet: { wallet_icon_id: @wallet.wallet_icon_id, name: "new 1", system: @wallet.system, value: @wallet.value } }))
    end


    sign_out @user
  end

  test "should not create wallet - same wallet form user A to user B" do
    sign_in @user
    assert_difference('Wallet.count', 0) do
      # To assert :forbidden
      assert_equal(403, post(wallets_url, params: { wallet: { wallet_icon_id: @wallet.wallet_icon_id, name: "new 1", user_id: @user2.id, system: @wallet.system, value: @wallet.value } }))
    end
    sign_out @user
  end

  test "should create wallet - same wallet form user A to user B Admin" do
    sign_in @admin
    assert_difference('Wallet.count', 1) do
      # To assert :forbidden
      post(wallets_url, params: { wallet: { wallet_icon_id: @wallet.wallet_icon_id, name: "new 1", user_id: @user2.id, system: @wallet.system, value: @wallet.value } })
      assert_redirected_to wallet_url(Wallet.last)
    end
    sign_out @admin
  end

  test "should not create wallet - wrong icon id" do
    sign_in @user
    assert_difference('Wallet.count', 0) do
      # To assert :forbidden
      post(wallets_url, params: { wallet: { wallet_icon_id: -1, name: "new 1", user_id: @user.id, system: @wallet.system, value: @wallet.value } })
      assert_response :unprocessable_entity
    end
    sign_out @user
  end

  test "should not create wallet - no params" do
    sign_in @user

    assert_difference('Wallet.count', 0) do
      post wallets_url, params: { }
      assert_redirected_to wallet404_url
    end

    sign_out @user
  end

  test "should create wallet" do
    sign_in @user
    assert_difference('Wallet.count') do
      # You don't need to pass the user id
      post wallets_url, params: { wallet: { wallet_icon_id: @wallet.wallet_icon_id, name: "new wallet", system: @wallet.system, value: @wallet.value } }
    end

    assert_redirected_to wallet_url(Wallet.last)

    sign_out @user
  end

  test "should show wallet" do
    sign_in @user

    get wallet_url(@wallet)
    assert_response :success

    check_header_login

    sign_out @user
  end

  test "should not show wallet - wrong user" do
    sign_in @user2
    get wallet_url(@wallet)
    assert_redirected_to wallet404_url
    sign_out @user2
  end

  test "should show wallet - wrong user but admin" do
    sign_in @admin
    get wallet_url(@wallet)
    assert_response :success
    sign_out @admin
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

  test "should get edit - wrong user but admin" do
    sign_in @admin
    get edit_wallet_url(@wallet)
    assert_response :success
    sign_out @admin
  end

  test "should not get edit - not exists" do
    sign_in @user
    get edit_wallet_url(-1)
    assert_redirected_to wallet404_url
    sign_out @user
  end

  test "should not get edit - system wallet" do
    sign_in @user

    get edit_wallet_url(@wallet2)
    assert_redirected_to wallet_url(@wallet2)

    sign_out @user
  end

  test "should get edit" do
    sign_in @user

    get edit_wallet_url(@wallet)
    assert_response :success

    check_header_login

    sign_out @user
  end

  test "should not update wallet - no user" do
    patch wallet_url(@wallet), params: { wallet: { wallet_icon_id: @wallet.wallet_icon_id, name: @wallet.name, value: @wallet.value } }
    assert_redirected_to new_user_session_url
  end

  test "should not update wallet - no wallet" do
    sign_in @user
    patch wallet_url(-1), params: { wallet: { wallet_icon_id: @wallet.wallet_icon_id, name: @wallet.name, value: @wallet.value } }
    assert_redirected_to wallet404_url
    sign_out @user
  end

  test "should not update wallet - wrong user" do
    sign_in @user2
    patch wallet_url(@wallet), params: { wallet: { wallet_icon_id: @wallet.wallet_icon_id, name: @wallet.name, value: @wallet.value } }
    assert_redirected_to wallet404_url
    sign_out @user2
  end

  test "should update wallet - wrong user but admin" do
    sign_in @admin
    patch wallet_url(@wallet), params: { wallet: { wallet_icon_id: @wallet.wallet_icon_id, name: @wallet.name, value: @wallet.value } }
    assert_redirected_to wallet_url(@wallet)
    sign_out @admin
  end

  test "should not update wallet - wrong wallet id" do
    sign_in @user
    patch wallet_url(@wallet), params: { wallet: { wallet_icon_id: -1, name: @wallet.name, value: @wallet.value } }
    assert_response :unprocessable_entity
    sign_out @user
  end

  test "should not update wallet - system wallet" do
    sign_in @user
    patch wallet_url(@wallet2), params: { wallet: { wallet_icon_id: @wallet.wallet_icon_id, name: @wallet.name, value: @wallet.value } }
    assert_redirected_to wallet_url(@wallet2)
    assert_equal I18n.t("wallet.messages.can_not_be_changed"), flash[:notice]
    sign_out @user
  end

  test "should update wallet" do
    sign_in @user
    patch wallet_url(@wallet), params: { wallet: { wallet_icon_id: @wallet.wallet_icon_id, name: @wallet.name, value: @wallet.value } }
    assert_redirected_to wallet_url(@wallet)
    sign_out @user
  end

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

  test "should destroy wallet - wrong user but admin" do
    sign_in @admin
    delete wallet_url(@wallet)
    assert_redirected_to dashboard_url
    sign_out @admin
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
