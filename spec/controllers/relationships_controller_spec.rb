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
  
end
