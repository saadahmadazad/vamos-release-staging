require 'test_helper'

class OtaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @otum = ota(:one)
  end

  test "should get index" do
    get ota_url
    assert_response :success
  end

  test "should get new" do
    get new_otum_url
    assert_response :success
  end

  test "should create otum" do
    assert_difference('Otum.count') do
      post ota_url, params: { otum: { account: @otum.account, crowl_status: @otum.crowl_status, facility_id: @otum.facility_id, last_crawl_at: @otum.last_crawl_at, name: @otum.name, password: @otum.password, provider: @otum.provider, status: @otum.status, token: @otum.token } }
    end

    assert_redirected_to otum_url(Otum.last)
  end

  test "should show otum" do
    get otum_url(@otum)
    assert_response :success
  end

  test "should get edit" do
    get edit_otum_url(@otum)
    assert_response :success
  end

  test "should update otum" do
    patch otum_url(@otum), params: { otum: { account: @otum.account, crowl_status: @otum.crowl_status, facility_id: @otum.facility_id, last_crawl_at: @otum.last_crawl_at, name: @otum.name, password: @otum.password, provider: @otum.provider, status: @otum.status, token: @otum.token } }
    assert_redirected_to otum_url(@otum)
  end

  test "should destroy otum" do
    assert_difference('Otum.count', -1) do
      delete otum_url(@otum)
    end

    assert_redirected_to ota_url
  end
end
