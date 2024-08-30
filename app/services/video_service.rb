
class VideoService
  def list_videos(page: 1, per_page: 12)
    Video.order(:created_at).page(page).per(per_page)
  end

  def get_video_by_id(id)
    Video.find(id)
  rescue ActiveRecord::RecordNotFound
    raise "Video with ID #{id} not found"
  end

  def get_videos_by_query(query, page: 1, per_page: 12)
    Video.where('title LIKE ?', "%#{query}%").order(:created_at).page(page).per(per_page)
  end
end
