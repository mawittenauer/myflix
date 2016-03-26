class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user, touch: true
  
  validates_presence_of :content, :rating
  
  delegate :title, to: :video, prefix: :video
end
