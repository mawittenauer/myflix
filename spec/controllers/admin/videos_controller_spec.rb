require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end
    it "sets @video to new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end
    it "sets the flash error message for regular user" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end
  
  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end
    
    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end
    
    context "with valid input" do
      let(:category) { Fabricate(:category) }
      
      before do
        set_current_admin
        post :create, video: { title: "Monk", category_id: category.id, description: "Detective Show" }
      end
      it "redirects to the add new video page" do
        expect(response).to redirect_to new_admin_video_path
      end
      it "creates a video" do
        expect(category.videos.count).to eq(1)
      end
      it "sets the flash success message" do
        expect(flash[:success]).to_not be_empty
      end
    end
    
    context "with invalid input" do
      let(:category) { Fabricate(:category) }
      
      before do
        set_current_admin
        post :create, video: { title: "", category_id: category.id, description: "" }
      end
      it "does not create a new video" do
        expect(Video.count).to eq(0)
      end
      it "renders the new template" do
        expect(response).to render_template 'new'
      end
      it "sets @video" do
        expect(assigns(:video)).to be_new_record
      end
      it "sets the flash danger message" do
        expect(flash[:danger]).to_not be_empty
      end
    end
  end
end
