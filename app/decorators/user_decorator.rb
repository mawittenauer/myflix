class UserDecorator < Draper::Decorator
  delegate_all
  
  def number_of_reviews
    object.reviews.count
  end
  
  def number_of_queue_items
    object.queue_items.count
  end
end
