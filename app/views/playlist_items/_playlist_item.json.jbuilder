json.extract! playlist_item, :id, :playlist_id, :video_id, :created_at, :updated_at
json.url playlist_item_url(playlist_item, format: :json)
