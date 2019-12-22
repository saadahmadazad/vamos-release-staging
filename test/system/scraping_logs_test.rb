require "application_system_test_case"

class ScrapingLogsTest < ApplicationSystemTestCase
  setup do
    @scraping_log = scraping_logs(:one)
  end

  test "visiting the index" do
    visit scraping_logs_url
    assert_selector "h1", text: "Scraping Logs"
  end

  test "creating a Scraping log" do
    visit scraping_logs_url
    click_on "New Scraping Log"

    fill_in "Crawl log", with: @scraping_log.crawl_log_id
    fill_in "Status", with: @scraping_log.status
    fill_in "Url", with: @scraping_log.url
    click_on "Create Scraping log"

    assert_text "Scraping log was successfully created"
    click_on "Back"
  end

  test "updating a Scraping log" do
    visit scraping_logs_url
    click_on "Edit", match: :first

    fill_in "Crawl log", with: @scraping_log.crawl_log_id
    fill_in "Status", with: @scraping_log.status
    fill_in "Url", with: @scraping_log.url
    click_on "Update Scraping log"

    assert_text "Scraping log was successfully updated"
    click_on "Back"
  end

  test "destroying a Scraping log" do
    visit scraping_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Scraping log was successfully destroyed"
  end
end
