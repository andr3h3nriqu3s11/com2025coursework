require 'test_helper'

class TrasanctionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trasanction = trasanctions(:one)
  end

  test "should get index" do
    get trasanctions_url
    assert_response :success
  end

  test "should get new" do
    get new_trasanction_url
    assert_response :success
  end

  test "should create trasanction" do
    assert_difference('Trasanction.count') do
      post trasanctions_url, params: { trasanction: { description: @trasanction.description, destination: @trasanction.destination, origin: @trasanction.origin, value: @trasanction.value } }
    end

    assert_redirected_to trasanction_url(Trasanction.last)
  end

  test "should show trasanction" do
    get trasanction_url(@trasanction)
    assert_response :success
  end

  test "should get edit" do
    get edit_trasanction_url(@trasanction)
    assert_response :success
  end

  test "should update trasanction" do
    patch trasanction_url(@trasanction), params: { trasanction: { description: @trasanction.description, destination: @trasanction.destination, origin: @trasanction.origin, value: @trasanction.value } }
    assert_redirected_to trasanction_url(@trasanction)
  end

  test "should destroy trasanction" do
    assert_difference('Trasanction.count', -1) do
      delete trasanction_url(@trasanction)
    end

    assert_redirected_to trasanctions_url
  end
end
