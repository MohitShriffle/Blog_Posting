require 'rails_helper'
RSpec.describe Subscription, type: :model do
  before(:all) do
    @subscription = FactoryBot.create(:subscription)
  end
  it 'is valid with valid attributes' do
    expect(@subscription).to be_valid
  end
  it 'is not valid without a start_date' do
    @subscription.start_date = nil
    expect(@subscription).to_not be_valid
  end

  it 'is not valid without a start_date' do
    @subscription.end_date = nil
    expect(@subscription).to_not be_valid
  end

  it 'is not valid without end status' do
    @subscription.status = nil
    expect(@subscription).to_not be_valid
  end

  it 'is not valid without a autorenewal' do
    @subscription.auto_renewal = nil
    expect(@subscription).to_not be_valid
  end
  
  it 'should have many subscriptions' do
    t = Subscription.reflect_on_association(:user)
    expect(t.macro).to eq(:belongs_to)
  end
  it 'should have many users' do
    t = Subscription.reflect_on_association(:plan)
    expect(t.macro).to eq(:belongs_to)
  end

end
