require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders show template if the token is valid" do
      alice = Fabricate(:user, token: '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end
    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
    
    it "sets @token" do
      alice = Fabricate(:user, token: '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq(alice.token)
    end
  end
  
  describe "POST create" do
    context "with valid token" do
      
      let(:alice) { Fabricate(:user, password: 'old_password') }
      
      before do
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: 'new_password'
      end
      
      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
      it "updates the users password" do
        expect(alice.reload.authenticate('new_password')).to be_truthy
      end
      it "sets the flash success message" do
        expect(flash[:success]).to be_present
      end
      it "regenerates the users token" do
        expect(alice.reload.token).not_to eq('12345')
      end
      it "deletes the users token" do
        expect(alice.reload.token).to be_nil
      end
    end
    
    context "with invalid token" do
      it "redirects to expired token path" do
        post :create, token: '12345', password: 'some_password'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end
