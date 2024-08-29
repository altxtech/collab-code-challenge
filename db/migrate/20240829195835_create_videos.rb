class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :video_id
      t.string :title
      t.integer :views
      t.integer :likes
      t.integer :comments
      t.text :description
      t.string :thumbnail_url

      t.timestamps
    end
  end
end
