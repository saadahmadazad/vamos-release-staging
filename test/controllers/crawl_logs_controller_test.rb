require 'test_helper'

class CrawlLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @crawl_log = crawl_logs(:one)
  end

  test "should get index" do
    get crawl_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_crawl_log_url
    assert_response :success
  end

  test "should create crawl_log" do
    assert_difference('CrawlLog.count') do
      post crawl_logs_url, params: { crawl_log: { ota_room_id: @crawl_log.ota_room_id, status: @crawl_log.status } }
    end

    assert_redirected_to crawl_log_url(CrawlLog.last)
  end

  test "should show crawl_log" do
    get crawl_log_url(@crawl_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_crawl_log_url(@crawl_log)
    assert_response :success
  end

  test "should update crawl_log" do
    patch crawl_log_url(@crawl_log), params: { crawl_log: { ota_room_id: @crawl_log.ota_room_id, status: @crawl_log.status } }
    assert_redirected_to crawl_log_url(@crawl_log)
  end

  test "should destroy crawl_log" do
    assert_difference('CrawlLog.count', -1) do
      delete crawl_log_url(@crawl_log)
    end

    assert_redirected_to crawl_logs_url
  end
end
