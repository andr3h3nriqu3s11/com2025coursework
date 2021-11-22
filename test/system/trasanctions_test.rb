require "application_system_test_case"

class TrasanctionsTest < ApplicationSystemTestCase
  setup do
    @trasanction = trasanctions(:one)
  end

  test "visiting the index" do
    visit trasanctions_url
    assert_selector "h1", text: "Trasanctions"
  end

  test "creating a Trasanction" do
    visit trasanctions_url
    click_on "New Trasanction"

    fill_in "Description", with: @trasanction.description
    fill_in "Destination", with: @trasanction.destination
    fill_in "Origin", with: @trasanction.origin
    fill_in "Value", with: @trasanction.value
    click_on "Create Trasanction"

    assert_text "Trasanction was successfully created"
    click_on "Back"
  end

  test "updating a Trasanction" do
    visit trasanctions_url
    click_on "Edit", match: :first

    fill_in "Description", with: @trasanction.description
    fill_in "Destination", with: @trasanction.destination
    fill_in "Origin", with: @trasanction.origin
    fill_in "Value", with: @trasanction.value
    click_on "Update Trasanction"

    assert_text "Trasanction was successfully updated"
    click_on "Back"
  end

  test "destroying a Trasanction" do
    visit trasanctions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Trasanction was successfully destroyed"
  end
end
