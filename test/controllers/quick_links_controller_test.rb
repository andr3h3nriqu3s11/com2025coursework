require 'test_helper'

class QuickLinksControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    @quick_link = quick_links(:one)
    @quick_link2 = quick_links(:two)
    @user = users(:one)
    @user2 = users(:two)
    @admin = users(:admin)
  end

  test "should not get new - no user" do
    get new_quick_link_url
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    sign_in @user

    get new_quick_link_url
    assert_response :success

    check_header_login

    sign_out @user
  end

  test "should not create quick_link - no user" do
    assert_difference('QuickLink.count', 0) do
      post quick_links_url, params: { quick_link: { destination_id: @quick_link.destination_id, name: @quick_link.name, origin_id: @quick_link.origin_id } }
    end

    assert_redirected_to new_user_session_path
  end

  test "should not create quick_link - no data" do
    sign_in @user

    assert_difference('QuickLink.count', 0) do
      post quick_links_url, params: { }
    end

    assert_redirected_to edit_user_registration_path

    sign_out @user
  end

  test "should not create quick_link - no name" do
    sign_in @user

    assert_difference('QuickLink.count', 0) do
      post quick_links_url, params: { quick_link: { destination_id: @quick_link.destination_id, name: "", origin_id: @quick_link.origin_id } }
    end

    assert_redirected_to new_quick_link_path

    sign_out @user
  end

  test "should not create Quick link - no origin_id" do
    sign_in @user
      assert_difference('QuickLink.count', 0) do
      post quick_links_url, params: { quick_link: { destination_id: @quick_link.destination_id, name: "" } }
    end
    assert_redirected_to new_quick_link_path
    sign_out @user
  end

  test "should not create Quick link - no destination_id" do
    sign_in @user
    assert_difference('QuickLink.count', 0) do
      post quick_links_url, params: { quick_link: { origin_id: @quick_link.origin_id, name: "" } }
    end

    assert_redirected_to new_quick_link_path
    sign_out @user
  end

  test "should create quick_link" do
    sign_in @user
    assert_difference('QuickLink.count') do
      post quick_links_url, params: { quick_link: { destination_id: @quick_link.destination_id, name: @quick_link.name + "new", origin_id: @quick_link.origin_id } }
    end

    assert_redirected_to quick_link_url(QuickLink.last)
    sign_out @user
  end

  test "should not get show - no user" do
    get quick_link_url(@quick_link)
    assert_redirected_to new_user_session_path
  end

  test "not should get show - no exists" do
    sign_in @user

    get quick_link_url(-1)
    assert_redirected_to edit_user_registration_path

    sign_out @user
  end

  test "not should get show - wrong user" do
    sign_in @user2

    get quick_link_url(@quick_link)
    assert_redirected_to edit_user_registration_path

    sign_out @user2
  end

  test "not should get show - wrong user but admin" do
    sign_in @admin

    get quick_link_url(@quick_link)
    assert_response :success

    check_header_login

    sign_out @admin
  end

  test "should get show" do
    sign_in @user

    get quick_link_url(@quick_link)
    assert_response :success

    check_header_login

    sign_out @user
  end

  test "should not get edit - no user" do
    get edit_quick_link_url(@quick_link)
    assert_redirected_to new_user_session_path
  end

  test "not should get edit - no exists" do
    sign_in @user

    get edit_quick_link_url(-1)
    assert_redirected_to edit_user_registration_path

    sign_out @user
  end

  test "not should get edit - wrong user" do
    sign_in @user2

    get edit_quick_link_url(@quick_link)
    assert_redirected_to edit_user_registration_path

    sign_out @user2
  end

  test "not should get edit - wrong user but admin" do
    sign_in @admin

    get edit_quick_link_url(@quick_link)
    assert_response :success

    check_header_login

    sign_out @admin
  end

  test "should get edit" do
    sign_in @user

    get edit_quick_link_url(@quick_link)
    assert_response :success

    check_header_login

    sign_out @user
  end

  test "should not update quick_link - no user" do
    patch quick_link_url(@quick_link), params: { quick_link: { destination_id: @quick_link.destination_id, name: @quick_link.name, origin_id: @quick_link.origin_id } }

    assert_redirected_to new_user_session_path
  end

  test "should not update quick_link - no data" do
    sign_in @user

    patch quick_link_url(@quick_link), params: { }

    assert_redirected_to edit_user_registration_path

    sign_out @user
  end

  test "should not update quick_link - no name" do
    sign_in @user

    patch quick_link_url(@quick_link), params: { quick_link: { destination_id: @quick_link.destination_id, name: "", origin_id: @quick_link.origin_id } }
    assert_response :unprocessable_entity

    sign_out @user
  end

  test "should update quick_link" do
    sign_in @user
    patch quick_link_url(@quick_link), params: { quick_link: { destination_id: @quick_link.destination_id, name: @quick_link.name + "new", origin_id: @quick_link.origin_id } }
    assert_redirected_to quick_link_url(@quick_link)
    sign_out @user
  end

  test "should not destroy quick link - no user" do
    delete quick_link_url(@quick_link)
    assert_redirected_to new_user_session_url
  end

  test "should not destroy quick_link - no user and not exists" do
    delete quick_link_url(-1)
    assert_redirected_to new_user_session_url
  end

  test "should not destroy quick_link - no not exists" do
    sign_in @user
    delete quick_link_url(-1)
    assert_redirected_to edit_user_registration_url
    sign_out @user
  end

  test "should not destroy quick_link - wrong user" do
    sign_in @user2
    delete quick_link_url(@quick_link)
    assert_redirected_to edit_user_registration_url
    sign_out @user2
  end

  test "should destroy quick_link - wrong user but admin" do
    sign_in @admin
    assert_difference('QuickLink.count', -1) do
      delete quick_link_url(@quick_link)
    end
    assert_redirected_to edit_user_registration_url
    sign_out @admin
  end

  test "should not destroy quick_link - not origin" do
    sign_in @user2
    delete quick_link_url(@quick_link2)
    assert_redirected_to quick_link_url(@quick_link2)
    sign_out @user2
  end

  test "should destroy quick_link" do
    sign_in @user
    assert_difference('QuickLink.count', -1) do
      delete quick_link_url(@quick_link)
    end
    assert_redirected_to edit_user_registration_url
    sign_out @user
  end
end
