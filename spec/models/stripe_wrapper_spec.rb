require 'spec_helper'

describe StripeWrapper do
  let(:token) do
    Stripe::Token.create(
      :card => {
        :number => '4242424242424242',
        :exp_month => 6,
        :exp_year => 2018,
        :cvc => 314
      }
    ).id
  end

  let(:decline_token) do
    Stripe::Token.create(
      :card => {
        :number => '4000000000000002',
        :exp_month => 6,
        :exp_year => 2018,
        :cvc => 314
      }
    ).id
  end
  
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token,
          description: "valid charge"
        )
        
        expect(response).to be_successful
      end
      
      it "makes a card decline charge", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token,
          description: "an invalid charge"
        )
        
        expect(response).to_not be_successful
      end
      
      it "returns the error message for declined charges", :vcr do        
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: decline_token,
          description: "valid charge"
        )
        
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
  
  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer witha  valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          card: token
        )
        
        expect(response).to be_successful
      end
      it "does not create a customer with declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          card: decline_token
        )
        
        expect(response).not_to be_successful
      end
      it "returns the error message for declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          card: decline_token
        )
        
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end
