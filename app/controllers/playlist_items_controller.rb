class PlaylistItemsController < ApplicationController
  # POST /playlist_items
  def create
    playlist_ids = params[:playlist_ids]
    video_id = params[:video_id]

    playlist_ids.each do |playlist_id|
      PlaylistItem.create(playlist_id: playlist_id, video_id: video_id)
    end

    redirect_to root_path, notice: "Video added to selected playlists."
  end

  # DELETE /playlist_items/:id
  def destroy
    playlist_item = PlaylistItem.find(params[:id])
    playlist_item.destroy

    redirect_back(fallback_location: root_path, notice: "Video removed from the playlist.")
  end
end
