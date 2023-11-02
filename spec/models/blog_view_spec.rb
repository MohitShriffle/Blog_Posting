require 'rails_helper'

RSpec.describe BlogView, type: :model do
  before(:all) do
    @blogview = FactoryBot.create(:blog_view)
  end
  it 'is valid with valid attributes' do
    expect(@blogview).to be_valid
  end
  it 'is valid with valid attributes' do
    @blogview.viewed_at = nil
    expect(@blogview).to be_valid
  end
  it 'should belongs_to Blog' do
    t = BlogView.reflect_on_association(:blog)
    expect(t.macro).to eq(:belongs_to)
  end
  it 'should belongs to User' do
    t = BlogView.reflect_on_association(:user)
    expect(t.macro).to eq(:belongs_to)
  end
end
