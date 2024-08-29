class PlaylistsController < ApplicationController
  before_action :set_playlist, only: %i[ show edit update destroy update_title remove_videos ]

  def index
    @playlists = PlaylistService.new.list_playlists

    if params[:context] == 'add_to_playlist' && params[:video_id].present?
      @video_id = params[:video_id]
      render partial: 'playlists/add_to_playlist'
    else
      render partial: 'playlists/list_playlists'
    end
  end

  def show
    playlists_service = PlaylistService.new

    @videos = playlists_service.get_playlist_items(@playlist.id)
        
  end

  def update_title
    if PlaylistService.new.update_playlist(@playlist.id, playlist_params[:name])
      redirect_to @playlist, notice: 'Failed to update playlist'
    else
      redirect_to @playlist, alert: 'Failed  to update playlist'
    end
  end

  def remove_videos
    playlist_service = PlaylistService.new

    # Split the video_ids string into an array of strings, then map them to integers
    video_ids = params[:video_ids].first.split(',').map(&:to_i)

    # Use the updated method to remove multiple items at once
    playlist_service.remove_playlist_items(@playlist.id, video_ids)

    redirect_to @playlist, notice: 'Selected videos were removed from the playlist.'
  end

  def new
    @playlist = Playlist.new
  end

  def create
    @playlist = PlaylistService.new.create_playlist(playlist_params[:name])

    respond_to do |format|
      if @playlist.persisted?
        format.html { redirect_to playlist_url(@playlist), notice: "Playlist was successfully created." }
        format.json { render :show, status: :created, location: @playlist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    PlaylistService.new.delete_playlist(@playlist.id)
    respond_to do |format|
      format.html { redirect_to playlists_url, notice: "Playlist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_playlist
      @playlist = PlaylistService.new.get_playlist_by_id(params[:id])
    end

    def playlist_params
      params.require(:playlist).permit(:name)
    end
end
