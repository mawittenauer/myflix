require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      
      before { post :create, email: "" }
      
      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end
      
      it "shows an error message" do
        expect(flash[:danger]).to eq("Email cannot be blank.")
      end
    end
    
    context "with existing email" do
            
      after { ActionMailer::Base.deliveries.clear }
      
      it "should redirect to the forgot password confirmation page" do
        joe = Fabricate(:user, email: "joe@example.com")
        post :create, email: "joe@example.com"
        expect(response).to redirect_to forgot_password_confirmation_path
      end
      
      it "sets a token for the user" do
        joe = Fabricate(:user, email: "joe@example.com")
        post :create, email: "joe@example.com"
        expect(joe.reload.token).to be_present
      end
      
      it "sends out an email to the email address" do
        joey = Fabricate(:user, email: "joe@example.com")
        post :create, email: "joe@example.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end
    end
    
    context "with non-existing email" do
      
      before { post :create, email: "foo@example.com" }
      
      it "redirect to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end
      
      it "shows an error message" do
        expect(flash[:danger]).to be_present
      end
    end
  end
end
