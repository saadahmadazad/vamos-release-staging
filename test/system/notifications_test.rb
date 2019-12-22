require "application_system_test_case"

class NotificationsTest < ApplicationSystemTestCase
  setup do
    @notification = notifications(:one)
  end

  test "visiting the index" do
    visit notifications_url
    assert_selector "h1", text: "Notifications"
  end

  test "creating a Notification" do
    visit notifications_url
    click_on "New Notification"

    fill_in "Status", with: @notification.status
    fill_in "Target", with: @notification.target_id
    fill_in "Target type", with: @notification.target_type
    fill_in "Type", with: @notification.type
    fill_in "Url", with: @notification.url
    click_on "Create Notification"

    assert_text "Notification was successfully created"
    click_on "Back"
  end

  test "updating a Notification" do
    visit notifications_url
    click_on "Edit", match: :first

    fill_in "Status", with: @notification.status
    fill_in "Target", with: @notification.target_id
    fill_in "Target type", with: @notification.target_type
    fill_in "Type", with: @notification.type
    fill_in "Url", with: @notification.url
    click_on "Update Notification"

    assert_text "Notification was successfully updated"
    click_on "Back"
  end

  test "destroying a Notification" do
    visit notifications_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Notification was successfully destroyed"
  end
end
