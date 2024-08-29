class VideoService
  def list_videos(page: 1, per_page: 10)
    Video.order(:created_at).page(page).per(per_page)
  end

  def get_video_by_id(id)
    Video.find(id)
  rescue ActiveRecord::RecordNotFound
    raise "Video with ID #{id} not found"
  end

  def get_videos_by_query(query, page: 1, per_page: 10)
    Video.where('title ILIKE ?', "%#{query}%").order(:created_at).page(page).per(per_page)
  end
end

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
    playlist_item.destroy
    playlist
  end
end


# Legacy. I used this early in development before I did the extraction to local db
# Not deleting for documentatin purposes
class YoutubeApiService
    include HTTParty
    base_uri 'https://mock-youtube-api-f3d0c17f0e38.herokuapp.com/api'
  
    def fetch_videos(page = 1)
      self.class.get('/videos', query: { page: page })
    end
  end