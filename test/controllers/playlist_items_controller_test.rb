require "test_helper"

class PlaylistItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @playlist_item = playlist_items(:one)
  end

  test "should get index" do
    get playlist_items_url
    assert_response :success
  end

  test "should get new" do
    get new_playlist_item_url
    assert_response :success
  end

  test "should create playlist_item" do
    assert_difference("PlaylistItem.count") do
      post playlist_items_url, params: { playlist_item: { playlist_id: @playlist_item.playlist_id, video_id: @playlist_item.video_id } }
    end

    assert_redirected_to playlist_item_url(PlaylistItem.last)
  end

  test "should show playlist_item" do
    get playlist_item_url(@playlist_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_playlist_item_url(@playlist_item)
    assert_response :success
  end

  test "should update playlist_item" do
    patch playlist_item_url(@playlist_item), params: { playlist_item: { playlist_id: @playlist_item.playlist_id, video_id: @playlist_item.video_id } }
    assert_redirected_to playlist_item_url(@playlist_item)
  end

  test "should destroy playlist_item" do
    assert_difference("PlaylistItem.count", -1) do
      delete playlist_item_url(@playlist_item)
    end

    assert_redirected_to playlist_items_url
  end
end
