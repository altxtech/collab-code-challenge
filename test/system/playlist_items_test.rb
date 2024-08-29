require "application_system_test_case"

class PlaylistItemsTest < ApplicationSystemTestCase
  setup do
    @playlist_item = playlist_items(:one)
  end

  test "visiting the index" do
    visit playlist_items_url
    assert_selector "h1", text: "Playlist items"
  end

  test "should create playlist item" do
    visit playlist_items_url
    click_on "New playlist item"

    fill_in "Playlist", with: @playlist_item.playlist_id
    fill_in "Video", with: @playlist_item.video_id
    click_on "Create Playlist item"

    assert_text "Playlist item was successfully created"
    click_on "Back"
  end

  test "should update Playlist item" do
    visit playlist_item_url(@playlist_item)
    click_on "Edit this playlist item", match: :first

    fill_in "Playlist", with: @playlist_item.playlist_id
    fill_in "Video", with: @playlist_item.video_id
    click_on "Update Playlist item"

    assert_text "Playlist item was successfully updated"
    click_on "Back"
  end

  test "should destroy Playlist item" do
    visit playlist_item_url(@playlist_item)
    click_on "Destroy this playlist item", match: :first

    assert_text "Playlist item was successfully destroyed"
  end
end
