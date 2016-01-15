class AddCategoryIdToVideos < ActiveRecord::Migration
  def change
  	add_column :videos, :category_id, :integer
  	add_column :videos, :created_at, :datetime
  	add_column :videos, :updated_at, :datetime
  end
end
