require 'test_helper'

class QuickLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quick_link = quick_links(:one)
  end

  test "should get index" do
    get quick_links_url
    assert_response :success
  end

  test "should get new" do
    get new_quick_link_url
    assert_response :success
  end

  test "should create quick_link" do
    assert_difference('QuickLink.count') do
      post quick_links_url, params: { quick_link: { destination_id: @quick_link.destination_id, name: @quick_link.name, origin_id: @quick_link.origin_id } }
    end

    assert_redirected_to quick_link_url(QuickLink.last)
  end

  test "should show quick_link" do
    get quick_link_url(@quick_link)
    assert_response :success
  end

  test "should get edit" do
    get edit_quick_link_url(@quick_link)
    assert_response :success
  end

  test "should update quick_link" do
    patch quick_link_url(@quick_link), params: { quick_link: { destination_id: @quick_link.destination_id, name: @quick_link.name, origin_id: @quick_link.origin_id } }
    assert_redirected_to quick_link_url(@quick_link)
  end

  test "should destroy quick_link" do
    assert_difference('QuickLink.count', -1) do
      delete quick_link_url(@quick_link)
    end

    assert_redirected_to quick_links_url
  end
end
