require 'spec_helper'

describe VideosController do
  
  describe "GET show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end
  end
  
  it "redirects user to the sign in page for unauthenticated user" do
    video = Fabricate(:video)
    get :show, id: video.id
    expect(response).to redirect_to sign_in_path
  end
  
  describe "GET search" do
    it "sets @results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      futurama = Fabricate(:video, title: "Futurama")
      get :search, search_term: "rama"
      expect(assigns(:results)).to eq([futurama])
    end
    
    it "redirects to sign in page for unauthenticated users" do
      futurama = Fabricate(:video, title: "Futurama")
      get :search, search_term: "rama"
      expect(response).to redirect_to sign_in_path
    end
  end
  
end
