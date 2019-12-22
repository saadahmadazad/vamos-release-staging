require "application_system_test_case"

class CrawlLogsTest < ApplicationSystemTestCase
  setup do
    @crawl_log = crawl_logs(:one)
  end

  test "visiting the index" do
    visit crawl_logs_url
    assert_selector "h1", text: "Crawl Logs"
  end

  test "creating a Crawl log" do
    visit crawl_logs_url
    click_on "New Crawl Log"

    fill_in "Ota room", with: @crawl_log.ota_room_id
    fill_in "Status", with: @crawl_log.status
    click_on "Create Crawl log"

    assert_text "Crawl log was successfully created"
    click_on "Back"
  end

  test "updating a Crawl log" do
    visit crawl_logs_url
    click_on "Edit", match: :first

    fill_in "Ota room", with: @crawl_log.ota_room_id
    fill_in "Status", with: @crawl_log.status
    click_on "Update Crawl log"

    assert_text "Crawl log was successfully updated"
    click_on "Back"
  end

  test "destroying a Crawl log" do
    visit crawl_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Crawl log was successfully destroyed"
  end
end
