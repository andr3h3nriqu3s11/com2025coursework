require 'test_helper'

class ContactControllerTest < ActionDispatch::IntegrationTest

  test "should get contact" do
    get contact_url
    assert_response :success
  end

  test "Post fail - no data" do
    post contact_url
    assert_response :redirect
    assert_nil flash[:notice]
    assert_not_empty flash[:alert]
  end

  test "Post fail - no subject" do
    post contact_url, params:
      {name: "Matthew", email: "matthew@me.com", message: "Hello"}

    assert_response :redirect
    assert_nil flash[:notice]
    assert_not_empty flash[:alert]
  end

  test "Post fail - no email" do
    post contact_url, params:
      {name: "Matthew", subject: "test", message: "Hello"}

    assert_response :redirect
    assert_nil flash[:notice]
    assert_not_empty flash[:alert]
  end

  test "Post fail - no name" do
    post contact_url, params:
      {message: "Matthew", subject: "test", email: "test@test.test"}

    assert_response :redirect
    assert_nil flash[:notice]
    assert_not_empty flash[:alert]
  end

  test "Post success" do
    post contact_url, params:
      {name: "Matthew", subject: "test", message: "message", email: "test@test.test"}

    assert_response :redirect
    assert_nil flash[:alert]
    assert_not_empty flash[:notice]
  end

  test "Post success - No message" do
    post contact_url, params:
      {name: "Matthew", subject: "test", email: "test@test.test"}

    assert_response :redirect
    assert_nil flash[:alert]
    assert_not_empty flash[:notice]
  end

end
