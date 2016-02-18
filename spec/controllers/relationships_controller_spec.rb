require 'spec_helper'

describe RelationshipsController do
  
  describe "GET index" do
    it "sets @relationships to the users following relationships" do
      mike = Fabricate(:user)
      set_current_user(mike)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: mike, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end
  
  describe "DELETE destroy" do
    
    let(:mike) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 4 }
    end
    
    it "deletes the relationship if the current user is the follower" do
      set_current_user(mike)
      relationship = Fabricate(:relationship, follower: mike, leader: bob)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end
    
    it "does not delete the relationship if the current user is not the follower" do
      set_current_user(mike)
      charlie = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: charlie)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
    
  end
  
  describe "POST create" do
    let(:mike) { Fabricate(:user) }
    let(:charlie) { Fabricate(:user) }
    
    it_behaves_like "requires sign in" do
      let(:action) { post :create, { leader_id: 2 } }
    end
    
    it "creates a new relationship with the current user as the follower" do
      set_current_user(mike)
      post :create, { leader_id: charlie.id }
      expect(mike.following_relationships.first.leader).to eq(charlie)
    end
    
    it "redirects to the people page" do
      set_current_user(mike)
      post :create, { leader_id: charlie.id }
      expect(response).to redirect_to people_path
    end
    
    it "does not create a relationships if the current user already follows the leader" do
      set_current_user(mike)
      Fabricate(:relationship, follower: mike, leader: charlie)
      post :create, { leader_id: charlie.id }
      expect(Relationship.count).to eq(1)
    end
    
    it "does not allow the user to follow himself" do
      set_current_user(mike)
      post :create, { leader_id: mike.id }
      expect(Relationship.count).to eq(0)
    end
  end
  
end
