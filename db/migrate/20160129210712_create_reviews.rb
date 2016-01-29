class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating, :user_id, :video_id
      t.text :content
      t.timestamps
    end
  end
end
