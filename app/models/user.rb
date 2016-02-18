class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :queue_items, -> { order "position" }
  has_many :reviews, -> { order "created_at DESC" }
  has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship"
  has_many :leading_relationships, foreign_key: "leader_id", class_name: "Relationship"
  
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
  
  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end
  
  def can_follow?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end
end
