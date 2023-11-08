require 'rails_helper'
RSpec.describe AutoRenewalWorker, type: :worker do
  describe '#perform' do

    context "when End date is yesterday auto renewal true" do
      let(:expired_subscription)  {FactoryBot.create(:subscription, auto_renewal: true, end_date: Date.yesterday, status: 'expired')}
      it 'Update Status' do 
        expect { AutoRenewalWorker.new.perform }.to change { Subscription.find(expired_subscription.id).status}.from('expired').to('active')
      end
    end
    
    context "when End date is tomorrow" do
      let(:active_subscription) {FactoryBot.create(:subscription, auto_renewal: true, end_date: Date.tomorrow, status: 'active')}
      it 'when End Date is tomorrow' do
        expect { AutoRenewalWorker.new.perform }.not_to change {Subscription.find(active_subscription.id).status}
      end
    end

    context "when End date is yesterday auto renewal false" do
      let(:non_renewal_subscription) {FactoryBot.create(:subscription, auto_renewal: false, end_date: Date.yesterday, status: 'active')}
      it 'when End Date is Yesterday' do
        expect { AutoRenewalWorker.new.perform }.not_to change {Subscription.find(non_renewal_subscription.id).status}
      end
    end
  end
end
