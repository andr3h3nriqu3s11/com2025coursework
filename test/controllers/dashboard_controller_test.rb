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
    sign_out @user
  end

end
