require 'httparty'

class VideoDataExtractor
  include HTTParty
  base_uri 'https://mock-youtube-api-f3d0c17f0e38.herokuapp.com/api'

  def self.extract_and_upsert_videos
    page = 1
    loop do
      response = get('/videos', query: { page: page })

      if response.success?
        videos = response['videos']

        videos.each do |video_data|
          Video.upsert({
            video_id: video_data['video_id'],
            title: video_data['title'],
            views: video_data['views'],
            likes: video_data['likes'],
            comments: video_data['comments'],
            description: video_data['description'],
            thumbnail_url: video_data['thumbnail_url'],
            created_at: video_data['created_at'],
            updated_at: video_data['updated_at']
          }, unique_by: :video_id)
        end

        # Break the loop if we've fetched all pages
        break if videos.empty? || page >= response['meta']['total']

        page += 1
      else
        puts "Failed to fetch videos from API."
        break
      end
    end
  end
end