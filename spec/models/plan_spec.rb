
require 'rails_helper'
RSpec.describe Plan, type: :model do
  before(:all) do
    @plan = FactoryBot.create(:plan)
  end
  it 'is valid with valid attributes' do
    expect(@plan).to be_valid
  end
  it 'is not valid without a name' do
    @plan.name = nil
    expect(@plan).to_not be_valid
  end

  it 'is not valid without reserve name' do
    (@plan.name == "Basic")
    expect(@plan).to_not be_valid
  end

  it 'is not valid without a duration' do
    @plan.duration = nil
    expect(@plan).to_not be_valid
  end

  it 'is not valid without a valid price' do
    @plan.price = nil
    expect(@plan).to_not be_valid
  end

  it 'is not valid without a valid active type' do
    @plan.active = nil
    expect(@plan).to_not be_valid
  end

  it 'should have many subscriptions' do
    t = Plan.reflect_on_association(:subscriptions)
    expect(t.macro).to eq(:has_many)
  end
  it 'should have many users' do
    t = Plan.reflect_on_association(:users)
    expect(t.macro).to eq(:has_many)
  end

end
