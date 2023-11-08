require 'rails_helper'
RSpec.describe ExpirationNotificationWorker,type: :worker do 
  describe 'perform' do
    context "when End date is yesterday auto renewal true" do
      let(:non_expired_subscription) {FactoryBot.create(:subscription, auto_renewal: true, end_date: Date.yesterday, status: 'active')}
      it 'Update Status' do
        UpdateSubscriptionStatusWorker.new.perform
        expect(Subscription.where(id: non_expired_subscription.id).first.status).to eq('active')
      end
    end
    context "when End date is tomorrow" do
      let(:non_expired_subscription)  {FactoryBot.create(:subscription, auto_renewal: true, end_date: Date.tomorrow, status: 'active')}
      it 'when End Date is tomorrow' do
        UpdateSubscriptionStatusWorker.new.perform
        expect(Subscription.where(id: non_expired_subscription.id).first.status).to eq('active')
      end
    end
    # context "when End date is yesterday auto renewal false" do
    #   # let(:expired_subscription) {FactoryBot.create(:subscription, auto_renewal: true, end_date: Date.yesterday, status: 'active')}
    #   let(:expired_subscription) {FactoryBot.create(:subscription, auto_renewal: false, end_date: Date.yesterday, status: 'active')}

    #   it 'when End Date is Yesterday' do
    #     UpdateSubscriptionStatusWorker.new.perform
    #     expect(Subscription.where(id: expired_subscription.id).first.status).to eq('expired')
    #   end
    # end
  end
end






















