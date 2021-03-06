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
      Fabricate.times(3, :queue_item, user_id: user.id)
      expect(user.number_of_queue_items).to eq(3)
    end
    
    it "returns 0 when the user has no videos" do
      expect(user.number_of_queue_items).to eq(0)
    end
  end
  
  describe "#follows?" do
    it "returns true if the user has a following relationships with another user" do
      mike = Fabricate(:user)
      charlie = Fabricate(:user)
      Fabricate(:relationship, follower: mike, leader: charlie)
      expect(mike.follows?(charlie)).to be_truthy
    end
    
    it "returns false if the user does not have a following relationship with another user" do
      mike = Fabricate(:user)
      charlie = Fabricate(:user)
      expect(mike.follows?(charlie)).to be_falsey
    end
  end
  
  describe "#follow" do
    it "follows another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      alice.follow(bob)
      expect(alice.follows?(bob)).to be_truthy
    end
    
    it "does not follow one self" do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.follows?(alice)).to be_falsey
    end
  end
  
end
