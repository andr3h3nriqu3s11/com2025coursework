require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
  end

  test "should not get dashboard" do
    get dashboard_dashboard_url
    assert_response :redirect
  end

  test "should get dashboard" do
    sign_in @user

    #This needs to be done since the dashboard is expecting the user to have the wallets that were created at runtime
    Wallet.create_default_wallets(@user.id)

    get dashboard_dashboard_url
    assert_response :success

    check_header_login

    #Checks that all the wallets from that user are shown
    assert_select ".wallet-icon" do |elms|
      assert_equal Wallet.by_user(@user).count, elms.length
    end

    #Checks that all the transactions from that user are shown
    assert_select ".transactionLineItem" do |elms|
      # We remove one for the header line which has the same selector of the rest of the lines
      assert_equal Transaction.by_user(@user).take(21).length, elms.length - 1
    end

    sign_out @user
  end

end
