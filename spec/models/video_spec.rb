require 'spec_helper'

describe Video do
  it { is_expected.to belong_to(:category) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  
  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end
    
    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "The Godfather")
        refresh_index
        expect(Video.search("whatver").records.to_a).to eq([])
      end
      
      it "returns an empty array when there's no search term" do
        the_godfather = Fabricate(:video)
        monk = Fabricate(:video)
        refresh_index
        expect(Video.search("").records.to_a).to eq([])
      end
      
      it "returns an array of 1 video for title case insensitive match" do
        the_godfather = Fabricate(:video, title: "The Godfather")
        monk = Fabricate(:video, title: "Monk")
        refresh_index
        expect(Video.search("the godfather").records.to_a).to eq([the_godfather])
      end
      
      it "returns an empty array of many videos for title match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        star_treck = Fabricate(:video, title: "Star Treck")
        refresh_index
        expect(Video.search("star").records.to_a).to match_array([star_wars, star_treck])
      end
      
      context "with title, description and reviews" do
        it 'returns an an empty array for no match with reviews option' do
          star_wars = Fabricate(:video, title: "Star Wars")
          batman    = Fabricate(:video, title: "Batman")
          batman_review = Fabricate(:review, video: batman, content: "such a star movie!")
          refresh_index

          expect(Video.search("no_match", reviews: true).records.to_a).to eq([])
        end

        it 'returns an array of many videos with relevance title > description > review' do
          star_wars = Fabricate(:video, title: "Star Wars")
          about_sun = Fabricate(:video, description: "the sun is a star!")
          batman    = Fabricate(:video, title: "Batman")
          batman_review = Fabricate(:review, video: batman, content: "such a star movie!")
          refresh_index

          expect(Video.search("star", reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
        end
      end
    end
    
    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index
        expect(Video.search("star").records.to_a).to match_array([star_wars, about_sun])
      end
    end
    
    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index
        expect(Video.search("Star Wars").records.to_a).to match_array([star_wars_1, star_wars_2])
      end
    end
  end
  
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
