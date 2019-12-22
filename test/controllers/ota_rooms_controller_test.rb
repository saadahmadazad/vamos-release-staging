require 'test_helper'

class OtaRoomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ota_room = ota_rooms(:one)
  end

  test "should get index" do
    get ota_rooms_url
    assert_response :success
  end

  test "should get new" do
    get new_ota_room_url
    assert_response :success
  end

  test "should create ota_room" do
    assert_difference('OtaRoom.count') do
      post ota_rooms_url, params: { ota_room: { ota_id: @ota_room.ota_id, room_id: @ota_room.room_id, status: @ota_room.status, uid: @ota_room.uid } }
    end

    assert_redirected_to ota_room_url(OtaRoom.last)
  end

  test "should show ota_room" do
    get ota_room_url(@ota_room)
    assert_response :success
  end

  test "should get edit" do
    get edit_ota_room_url(@ota_room)
    assert_response :success
  end

  test "should update ota_room" do
    patch ota_room_url(@ota_room), params: { ota_room: { ota_id: @ota_room.ota_id, room_id: @ota_room.room_id, status: @ota_room.status, uid: @ota_room.uid } }
    assert_redirected_to ota_room_url(@ota_room)
  end

  test "should destroy ota_room" do
    assert_difference('OtaRoom.count', -1) do
      delete ota_room_url(@ota_room)
    end

    assert_redirected_to ota_rooms_url
  end
end
