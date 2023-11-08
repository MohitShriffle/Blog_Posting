require 'rails_helper'
RSpec.describe ExpirationNotificationWorker,type: :worker do 
  let(:subscription){ FactoryBot.build(:subscription, end_date: Date.tomorrow) } 
  describe "perform" do
    context "Testing Subscription Worker" do
      it "it send mail to user" do
        subscription.save
        # expect { post :create, reservation_params }.to change { ActionMailer::Base.deliveries.count }.by(1)

        ExpirationNotificationWorker.new.perform
      end
    end
  end
end