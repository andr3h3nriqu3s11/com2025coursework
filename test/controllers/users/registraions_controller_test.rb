require 'test_helper'

class ContactControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @admin = users(:admin)
  end

  # Only this test is being done since it was the only controller action that I changed from the
  # the default devise ones
  test "create new user" do
    assert_difference "Wallet.count", 3 do
      # The root path is the same as the users path see the routes file and the base path has been
      # set to "" which makes it the root path
      post root_path, params: { user: {
        email: "email@email.eamil",
        password: "testtest",
        password_repeat: "testtest"
      }}
    end

    assert_redirected_to root_url
  end

  test "should not get index - no user" do

    get users_url
    assert_redirected_to new_user_session_path

  end

  test "should not get index - not admin" do
    sign_in @user

    get users_url
    assert_redirected_to dashboard_url

    sign_out @user
  end

  test "should get index" do
    sign_in @admin

    get users_url
    assert_response :success

    assert_select ".userLineItem" do |elms|
      # We remove one for the header line which has the same selector of the rest of the lines
      assert_equal User.all.length, elms.length - 1
    end

    sign_out @admin
  end

end
