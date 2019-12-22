require "application_system_test_case"

class OtaTest < ApplicationSystemTestCase
  setup do
    @otum = ota(:one)
  end

  test "visiting the index" do
    visit ota_url
    assert_selector "h1", text: "Ota"
  end

  test "creating a Otum" do
    visit ota_url
    click_on "New Otum"

    fill_in "Account", with: @otum.account
    fill_in "Crowl status", with: @otum.crowl_status
    fill_in "Facility", with: @otum.facility_id
    fill_in "Last crawl at", with: @otum.last_crawl_at
    fill_in "Name", with: @otum.name
    fill_in "Password", with: @otum.password
    fill_in "Provider", with: @otum.provider
    fill_in "Status", with: @otum.status
    fill_in "Token", with: @otum.token
    click_on "Create Otum"

    assert_text "Otum was successfully created"
    click_on "Back"
  end

  test "updating a Otum" do
    visit ota_url
    click_on "Edit", match: :first

    fill_in "Account", with: @otum.account
    fill_in "Crowl status", with: @otum.crowl_status
    fill_in "Facility", with: @otum.facility_id
    fill_in "Last crawl at", with: @otum.last_crawl_at
    fill_in "Name", with: @otum.name
    fill_in "Password", with: @otum.password
    fill_in "Provider", with: @otum.provider
    fill_in "Status", with: @otum.status
    fill_in "Token", with: @otum.token
    click_on "Update Otum"

    assert_text "Otum was successfully updated"
    click_on "Back"
  end

  test "destroying a Otum" do
    visit ota_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Otum was successfully destroyed"
  end
end
