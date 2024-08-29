class PlaylistsController < ApplicationController
  before_action :set_playlist, only: %i[ show edit update destroy ]

  # GET /playlists or /playlists.json
  def index
    @playlists = Playlist.all

    if params[:context] == 'add_to_playlist' && params[:video_id].present?
      @video_id = params[:video_id]
      render partial: 'playlists/add_to_playlist'
    else
      render partial: 'playlists/list_playlists'
    end
  end

  # GET /playlists/1 or /playlists/1.json
  def show
    youtube_service = YoutubeApiService.new

    @playlist = Playlist.find(params[:id])
    @playlist_items = @playlist.playlist_items.includes(:playlist)
    @videos = []  # Initialize the @videos array
    playlist_video_ids = @playlist_items.map(&:video_id)
    page = 1

    # Search videos in a loop
    loop do
      response = youtube_service.fetch_videos(page)

      if response.success?
        videos = response['videos']
        @meta = response['meta']

        # Filter videos where the id matches the playlist items
        matching_videos = videos.select { |video| playlist_video_ids.include?(video['id'].to_s) }

        # Append matching videos to the @videos array
        @videos.concat(matching_videos)

        # Break if all videos have been found or no more pages to fetch
        break if @videos.size >= playlist_video_ids.size || @meta['page'] >= (@meta['total'] / 10.0).ceil

        # Increment the page counter to fetch the next set of videos
        page += 1
        
      else
        flash[:alert] = "Failed to fetch videos"
        break
      end
    end
  end

  def update_title
    @playlist = Playlist.find(params[:id])
    if @playlist.update(playlist_params)
      redirect_to @playlist, notice: 'Playlist title updated successfully.'
    else
      redirect_to @playlist, alert: 'Failed to update playlist title.'
    end
  end

  def remove_videos
    @playlist = Playlist.find(params[:id])
    video_ids = params[:video_ids] || []

    @playlist.playlist_items.where(video_id: video_ids).destroy_all

    redirect_to @playlist, notice: 'Selected videos were removed from the playlist.'
  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
  end

  # GET /playlists/1/edit
  def edit
    @playlist = Playlist.find(params[:id])
  end

  # POST /playlists or /playlists.json
  def create
    @playlist = Playlist.new(playlist_params)

    respond_to do |format|
      if @playlist.save
        format.html { redirect_to playlist_url(@playlist), notice: "Playlist was successfully created." }
        format.json { render :show, status: :created, location: @playlist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlists/1 or /playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to playlist_url(@playlist), notice: "Playlist was successfully updated." }
        format.json { render :show, status: :ok, location: @playlist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1 or /playlists/1.json
  def destroy
    @playlist.destroy

    respond_to do |format|
      format.html { redirect_to playlists_url, notice: "Playlist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def playlist_params
      params.require(:playlist).permit(:name)
    end
end
