require 'spec_helper'

describe Video do
  it { is_expected.to belong_to(:category) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  
  describe ".search_by_title" do
    
    it "returns an empty array if there is no match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("hello")).to eq([])
    end
    
    it "returns an array of one video for an exact match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("Futurama")).to eq([futurama])
    end
    
    it "returns an array of a one video for a partial match" do
      futurama = Video.create(title: "Futurama", description: "Space Travel")
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("urama")).to eq([futurama])
    end
    
    it "returns an array of all matches ordered by created_at" do
      futurama = Video.create(title: "Futurama", description: "Space Travel", created_at: 1.day.ago)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("Futur")).to eq([back_to_future, futurama])
    end
    
    it "returns an empty array when the search is an empty string" do
      futurama = Video.create(title: "Futurama", description: "Space Travel", created_at: 1.day.ago)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel")
      expect(Video.search_by_title("")).to eq([])
    end
    
  end
end
