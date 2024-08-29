class PlaylistService
  def create_playlist(name)
    Playlist.create!(name: name)
  end

  def list_playlists
    Playlist.all
  end

  def get_playlist_by_id(id)
    Playlist.find(id)
  rescue ActiveRecord::RecordNotFound
    raise "Playlist with ID #{id} not found"
  end

  def update_playlist(id, name)
    playlist = get_playlist_by_id(id)
    playlist.update!(name: name)
    playlist
  end

  def delete_playlist(id)
    playlist = get_playlist_by_id(id)
    playlist.destroy
  end

  def add_playlist_item(playlist_id, video_id)
    playlist = get_playlist_by_id(playlist_id)
    video = VideoService.new.get_video_by_id(video_id)
    PlaylistItem.create!(playlist: playlist, video_id: video.id)
    playlist
  end

  def get_playlist_items(playlist_id, page: 1, per_page: 10)
    playlist = get_playlist_by_id(playlist_id)
    video_ids = playlist.playlist_items.pluck(:video_id)
    Video.where(id: video_ids).order(:created_at).page(page).per(per_page)
  end

  def remove_playlist_item(playlist_id, video_id)
    playlist = get_playlist_by_id(playlist_id)
    playlist_item = playlist.playlist_items.find_by(video_id: video_id)

    if playlist_item
      playlist_item.destroy
    else
      Rails.logger.warn("PlaylistItem not found for video_id #{video_id} in playlist #{playlist_id}")
    end

    playlist
  end

  def remove_playlist_items(playlist_id, video_ids)
    playlist = get_playlist_by_id(playlist_id)
    playlist_items = playlist.playlist_items.where(video_id: video_ids)
    Rails.logger.info "Removing items IDs: #{playlist_items.inspect}"

    if playlist_items.any?
        playlist_items.destroy_all
    else
        Rails.logger.warn("No playlist items found with video_ids: #{video_ids} in playlist #{playlist_id}")
    end

    playlist
  end
end
