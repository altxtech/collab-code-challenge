class HomeController < ApplicationController
  def index
    youtube_service = YoutubeApiService.new

    if params[:query].present?
      @videos = []
      page = 1

      loop do
        response = youtube_service.fetch_videos(page)

        if response.success?
          videos = response['videos']
          @meta = response['meta']

          # Filter videos by search query
          filtered_videos = videos.select { |video| video['title'].downcase.include?(params[:query].downcase) }
          @videos.concat(filtered_videos)

          # Break the loop if there are no more pages to fetch
          break if @meta['page'] >= (@meta['total'] / 10.0).ceil

          # Increment the page counter to fetch the next set of videos
          page += 1
        else
          flash[:alert] = "Failed to fetch videos"
          break
        end
      end

      # Set page to 1
      page = 1

      # Paginate the @videos array to show only videos for the current page
      @videos = Kaminari.paginate_array(@videos).page(params[:page]).per(10)

      # Flash a message if no videos match the search query
      flash[:notice] = "No videos found matching your search criteria" if @videos.empty?
    else
      # Normal pagination and fetching if no search query is provided
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

  def show
    youtube_service = YoutubeApiService.new
    video_id = params[:id]

    response = youtube_service.fetch_videos
    if response.success?
      videos = response['videos']
      @video = videos.find { |v| v['id'].to_s == video_id }

      unless @video
        flash[:alert] = "Video not found"
        redirect_to root_path
      end
    else
      flash[:alert] = "Failed to fetch video details"
      redirect_to root_path
    end
  end
end