# frozen_string_literal: true

require 'rails_helper'
RSpec.describe User, type: :model do
  before(:all) do
    @user = FactoryBot.create(:user)
  end
  # after(:all) do
  #   @user.destroy
  # end
  it 'is valid with valid attributes' do
    expect(@user).to be_valid
  end
  it 'is not valid without a name' do
    @user.name = nil
    expect(@user).to_not be_valid
  end
  it 'is not valid without a user_name' do
    @user.user_name = nil
    expect(@user).to_not be_valid
  end

  it 'is not valid without a valid email' do
    @user.email = @user.validate_email
    expect(@user).to_not be_valid
  end

  it 'is not valid without a password' do
    @user.password = nil
    expect(@user).to_not be_valid
  end

  it 'is not valid without a type' do
    @user.type = nil
    expect(@user).to_not be_valid
  end

  it 'it is not valid ' do
    token = @user.generate_otp
    !expect(token).nil?
  end

  it 'should have many blogs' do
    t = User.reflect_on_association(:blogs)
    expect(t.macro).to eq(:has_many)
  end
  it 'should have subscription' do
    t = User.reflect_on_association(:subscription)
    expect(t.macro).to eq(:has_one)
  end
  it 'should have blogviews' do
    t = User.reflect_on_association(:blogviews)
    expect(t.macro).to eq(:has_many)
  end
  it 'should have blogviews' do
    t = User.reflect_on_association(:plan)
    expect(t.macro).to eq(:belongs_to)
  end
end
