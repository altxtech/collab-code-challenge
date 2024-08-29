class YoutubeApiService
    include HTTParty
    base_uri 'https://mock-youtube-api-f3d0c17f0e38.herokuapp.com/api'
  
    def fetch_videos(page = 1)
      self.class.get('/videos', query: { page: page })
    end
  end