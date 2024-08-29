class AddUniqueIndexToVideoId < ActiveRecord::Migration[7.0]
  def change
    add_index :videos, :video_id, unique: true
  end
end
