class PlaylistItemsController < ApplicationController
  before_action :set_playlist_item, only: %i[ show edit update destroy ]

  # GET /playlist_items or /playlist_items.json
  def index
    @playlist_items = PlaylistItem.all
  end

  # GET /playlist_items/1 or /playlist_items/1.json
  def show
  end

  # GET /playlist_items/new
  def new
    @playlist_item = PlaylistItem.new
  end

  # GET /playlist_items/1/edit
  def edit
  end

  # POST /playlist_items or /playlist_items.json
  def create
    @playlist_item = PlaylistItem.new(playlist_item_params)

    respond_to do |format|
      if @playlist_item.save
        format.html { redirect_to playlist_item_url(@playlist_item), notice: "Playlist item was successfully created." }
        format.json { render :show, status: :created, location: @playlist_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @playlist_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playlist_items/1 or /playlist_items/1.json
  def update
    respond_to do |format|
      if @playlist_item.update(playlist_item_params)
        format.html { redirect_to playlist_item_url(@playlist_item), notice: "Playlist item was successfully updated." }
        format.json { render :show, status: :ok, location: @playlist_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @playlist_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlist_items/1 or /playlist_items/1.json
  def destroy
    @playlist_item.destroy

    respond_to do |format|
      format.html { redirect_to playlist_items_url, notice: "Playlist item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist_item
      @playlist_item = PlaylistItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def playlist_item_params
      params.require(:playlist_item).permit(:playlist_id, :video_id)
    end
end
