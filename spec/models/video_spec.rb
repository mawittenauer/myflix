require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "The Godfather", description: "Mob Movie")
    video.save
    expect(Video.first).to eq(video)
  end
  
  it "belongs to a category" do
    drama = Category.create(name: "Drama")
    monk = Video.create(title: "Monk", description: "A detective show!", category: drama)
    expect(monk.category).to eq(drama)
  end
end
