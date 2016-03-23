require 'spec_helper'

describe UsersController do
  
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  
  describe "POST create", :vcr do      
    
    context "sending emails" do
      after { ActionMailer::Base.deliveries.clear }
      let(:customer) { double(:customer, successful?: true) }
        
      before { StripeWrapper::Customer.stub(:create).and_return(customer) }
      
      it "sends an email" do
        post :create, user: Fabricate.attributes_for(:user, email: "mike@example.com", full_name: "Mike Wittenauer")
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end
      
      it "doesn't send an email when input is invalid" do
        post :create, user: Fabricate.attributes_for(:user, email: "", full_name: "Mike Wittenauer")
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
    
    context "valid personal info and declined card" do
      it "does not create a new user" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Customer.stub(:create).and_return(customer)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
        expect(User.count).to eq(0)
      end
      it "renders the new template" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Customer.stub(:create).and_return(customer)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
        expect(response).to render_template :new
      end
      it "sets the flash error messsage" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Customer.stub(:create).and_return(customer)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
        expect(flash[:danger]).to be_present
      end
    end
    
    context "with invalid input" do
      before do
        post :create, user: { email: "", password: "password", full_name: "Kevin Wang" }
      end
    
      it "does not create the user" do
        expect(User.count).to eq(0)
      end
    
      it "renders the :new template" do
        expect(response).to render_template :new
      end
    
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
      it "does not charge the card" do
        expect(StripeWrapper::Charge).to_not receive(:create)
      end
    end
  end
  
  describe "GET show" do
    context "with authenticated user" do
      it "sets @user" do
        set_current_user
        user = Fabricate(:user)
        get :show, id: user.id
        expect(assigns(:user)).to eq(user)
      end
      
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end
    
  end
  
  describe "GET new_with_invitation_token" do
    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end
    
    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
    
    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end
end
