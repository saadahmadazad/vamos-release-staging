require "application_system_test_case"

class BookingsTest < ApplicationSystemTestCase
  setup do
    @booking = bookings(:one)
  end

  test "visiting the index" do
    visit bookings_url
    assert_selector "h1", text: "Bookings"
  end

  test "creating a Booking" do
    visit bookings_url
    click_on "New Booking"

    fill_in "Checkin", with: @booking.checkin
    fill_in "Checkout", with: @booking.checkout
    fill_in "Count room", with: @booking.count_room
    fill_in "Price", with: @booking.price
    fill_in "Price balance", with: @booking.price_balance
    fill_in "Price total", with: @booking.price_total
    fill_in "Status", with: @booking.status
    fill_in "Uid", with: @booking.uid
    click_on "Create Booking"

    assert_text "Booking was successfully created"
    click_on "Back"
  end

  test "updating a Booking" do
    visit bookings_url
    click_on "Edit", match: :first

    fill_in "Checkin", with: @booking.checkin
    fill_in "Checkout", with: @booking.checkout
    fill_in "Count room", with: @booking.count_room
    fill_in "Price", with: @booking.price
    fill_in "Price balance", with: @booking.price_balance
    fill_in "Price total", with: @booking.price_total
    fill_in "Status", with: @booking.status
    fill_in "Uid", with: @booking.uid
    click_on "Update Booking"

    assert_text "Booking was successfully updated"
    click_on "Back"
  end

  test "destroying a Booking" do
    visit bookings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Booking was successfully destroyed"
  end
end
