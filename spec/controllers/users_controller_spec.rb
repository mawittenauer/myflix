require 'spec_helper'

describe UsersController do
  
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  
  describe "POST create" do
    
    context "with valid input" do
      before do 
        post :create, user: Fabricate.attributes_for(:user)
      end
      
      it "creates the user" do
        expect(User.count).to eq(1)
      end
      
      it_behaves_like "requires sign in" do
        let(:action) {}
      end
    end
    
    context "sending emails" do
      after { ActionMailer::Base.deliveries.clear }
      
      it "sends an email" do
        post :create, user: Fabricate.attributes_for(:user, email: "mike@example.com", full_name: "Mike Wittenauer")
        expect(ActionMailer::Base.deliveries).to_not be_empty
      end
      
      it "sends the email to the correct user" do
        post :create, user: Fabricate.attributes_for(:user, email: "mike@example.com", full_name: "Mike Wittenauer")
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq(["mike@example.com"])
      end
      
      it "sends the email containg user's name" do
        post :create, user: Fabricate.attributes_for(:user, email: "mike@example.com", full_name: "Mike Wittenauer")
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to have_content "Mike Wittenauer"
      end
      
      it "doesn't send an email when input is invalid" do
        post :create, user: Fabricate.attributes_for(:user, email: "", full_name: "Mike Wittenauer")
        expect(ActionMailer::Base.deliveries).to be_empty
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
end
