class HomeController < ApplicationController
  def index
    video_service = VideoService.new

    # Preprocessing --> make sure page is inteter
    if params[:page].present?
      params[:page] = params[:page].to_i
    end

    # Handle Search
    if params[:query].present?
      @videos = video_service.get_videos_by_query(params[:query], page: params[:page] || 1)
      @meta = { 'total' => @videos.total_count, 'page' => params[:page] || 1 }
 
      if @videos.empty?
        flash[:notice] = "No videos found matching your search criteria"
      end
    # Handle regular browsing
    else
      @videos = video_service.list_videos(page: params[:page] || 1)
      @meta = { 'total' => @videos.total_count, 'page' => params[:page] || 1 }
 
      if @videos.empty?
        flash[:alert] = "Failed to fetch videos"
      end
    end

    # Postprocessing --> Make sure meta page is not nil (breaks view)
    @meta['page'] ||= 1
  end
  def show
      video_service = VideoService.new
      video_id = params[:id].to_i

      begin
        # Fetch the video details by its ID
        @video = video_service.get_video_by_id(video_id)

      rescue StandardError => e
        flash[:alert] = "An error occurred: #{e.message}"
        redirect_to root_path
      end
    end  
end