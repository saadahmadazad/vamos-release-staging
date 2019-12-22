require "application_system_test_case"

class OtaRoomsTest < ApplicationSystemTestCase
  setup do
    @ota_room = ota_rooms(:one)
  end

  test "visiting the index" do
    visit ota_rooms_url
    assert_selector "h1", text: "Ota Rooms"
  end

  test "creating a Ota room" do
    visit ota_rooms_url
    click_on "New Ota Room"

    fill_in "Ota", with: @ota_room.ota_id
    fill_in "Room", with: @ota_room.room_id
    fill_in "Status", with: @ota_room.status
    fill_in "Uid", with: @ota_room.uid
    click_on "Create Ota room"

    assert_text "Ota room was successfully created"
    click_on "Back"
  end

  test "updating a Ota room" do
    visit ota_rooms_url
    click_on "Edit", match: :first

    fill_in "Ota", with: @ota_room.ota_id
    fill_in "Room", with: @ota_room.room_id
    fill_in "Status", with: @ota_room.status
    fill_in "Uid", with: @ota_room.uid
    click_on "Update Ota room"

    assert_text "Ota room was successfully updated"
    click_on "Back"
  end

  test "destroying a Ota room" do
    visit ota_rooms_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ota room was successfully destroyed"
  end
end
