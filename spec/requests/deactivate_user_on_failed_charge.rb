require 'spec_helper'

describe "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_17t1MZFz4N3HhUVcamwGNPGA",
      "object" => "event",
      "api_version" => "2016-03-07",
      "created" => 1458937015,
      "data" => {
        "object" => {
          "id" => "ch_17t1MZFz4N3HhUVc4I8Gu3cw",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1458937015,
          "currency" => "usd",
          "customer" => "cus_89ApiRFvtizlXW",
          "description" => "payment to fail",
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {},
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {},
          "order" => nil,
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_17t1MZFz4N3HhUVc4I8Gu3cw/refunds"
          },
          "shipping" => nil,
          "source" => {
            "id" => "card_17t1L5Fz4N3HhUVc68rxcVUK",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_zip_check" => nil,
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_89ApiRFvtizlXW",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 3,
            "exp_year" => 2017,
            "fingerprint" => "aswluvZK5AfHIcvT",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {},
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => nil,
          "status" => "failed"
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => "req_89K0HTcybh2p6E",
      "type" => "charge.failed"
    }
  end
  
  it "deactivates a user with the web hook data from stripe for charge failed", :vcr do
    alice = Fabricate(:user, customer_token: "cus_89ApiRFvtizlXW")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end














