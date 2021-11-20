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
    get dashboard_dashboard_url
    assert_response :success
    sign_out @user
  end

end
