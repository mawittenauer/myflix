class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :queue_items, -> { order "position" }
  has_many :reviews, -> { order "created_at DESC" }
  
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email
  
  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end
  
  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end
  
  def number_of_queue_items
    queue_items.count
  end
  
  def number_of_reviews
    reviews.count
  end
end
