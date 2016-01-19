require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Drama")
    category.save
    expect(Category.first).to eq(category)
  end
  
  it "has many videos" do
    drama = Category.new(name: "Drama")
    the_godfather = Video.create(title: "The Godfather", description: "Mafia movie!", category: drama)
    saving_private_ryan = Video.create(title: "Saving Private Ryan", description: "War movie!", category: drama)
    expect(drama.videos).to eq([saving_private_ryan, the_godfather])
  end
end

