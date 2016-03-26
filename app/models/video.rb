class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ["myflix", Rails.env].join('_')
  
  belongs_to :category
  has_many :reviews, -> { order "created_at DESC" }
  has_many :queue_items
  
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  
  validates_presence_of :title, :description
  
  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title ILIKE ?", "%#{search_term}%").order("created_at DESC")
  end
  
  def self.search(query, options = {})
    search = {
      query: {
        multi_match: {
          query: query,
          fields: ["title^100", "description^50"],
          operator: "and"
        }
      }
    }
    
    if query.present? && options[:reviews].present?
      search[:query][:multi_match][:fields] << "reviews.content"
    end
    
    if options[:rating_from].present? || options[:rating_to].present?
      search[:filter] = {
        range: {
          rating: {
            gte: (options[:rating_from] if options[:rating_from].present?),
            lte: (options[:rating_to] if options[:rating_to].present?)
          }  
        }  
      }
    end
    
    __elasticsearch__.search(search)
  end
  
  def rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end
  
  def as_indexed_json(options = {})
    as_json(
      methods: [:rating],
      only: [:title, :description, :reviews], 
      include: {
        reviews: { only: [:content] } 
      }
    )
  end
end
