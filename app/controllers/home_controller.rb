class HomeController < ApplicationController
  def index
    youtube_service = YoutubeApiService.new
    response = youtube_service.fetch_videos(params[:page])
    
    if response.success?
      @videos = response['videos']
      @meta = response['meta']
    else
      @videos = []
      flash[:alert] = "Failed to fetch videos"
    end
  end
end
