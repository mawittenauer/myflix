require 'spec_helper'

describe User do

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:full_name) }
  it { is_expected.to validate_uniqueness_of(:email) }
  
  describe "#queued_video?" do
    it "returns true when the users queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be_truthy
    end
    
    it "returns false when the user did not queue the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be_falsy
    end
  end
  
  describe "#number_of_queue_items" do
    let(:user) { Fabricate(:user) }
    it "returns 3 when the user has three videos" do
      Fabricate(:queue_item, user_id: user.id)
      Fabricate(:queue_item, user_id: user.id)
      Fabricate(:queue_item, user_id: user.id)
      expect(user.number_of_queue_items).to eq(3)
    end
    
    it "returns 0 when the user has no videos" do
      expect(user.number_of_queue_items).to eq(0)
    end
  end
  
  describe "#number_of_reviews" do
    let(:user) { Fabricate(:user) }
    it "returns 3 when the user has 3 reviews" do
      Fabricate(:review, user_id: user.id)
      Fabricate(:review, user_id: user.id)
      Fabricate(:review, user_id: user.id)
      expect(user.number_of_reviews).to eq(3)
    end
    
    it "returns 0 when the user has no reviews" do
      expect(user.number_of_reviews).to eq(0)
    end
  end
  
end
