require 'test_helper'

class ScrapingLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scraping_log = scraping_logs(:one)
  end

  test "should get index" do
    get scraping_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_scraping_log_url
    assert_response :success
  end

  test "should create scraping_log" do
    assert_difference('ScrapingLog.count') do
      post scraping_logs_url, params: { scraping_log: { crawl_log_id: @scraping_log.crawl_log_id, status: @scraping_log.status, url: @scraping_log.url } }
    end

    assert_redirected_to scraping_log_url(ScrapingLog.last)
  end

  test "should show scraping_log" do
    get scraping_log_url(@scraping_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_scraping_log_url(@scraping_log)
    assert_response :success
  end

  test "should update scraping_log" do
    patch scraping_log_url(@scraping_log), params: { scraping_log: { crawl_log_id: @scraping_log.crawl_log_id, status: @scraping_log.status, url: @scraping_log.url } }
    assert_redirected_to scraping_log_url(@scraping_log)
  end

  test "should destroy scraping_log" do
    assert_difference('ScrapingLog.count', -1) do
      delete scraping_log_url(@scraping_log)
    end

    assert_redirected_to scraping_logs_url
  end
end
