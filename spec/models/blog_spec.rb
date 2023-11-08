
require 'rails_helper'
RSpec.describe Blog, type: :model do
  before(:all) do
    @blog = FactoryBot.create(:blog)
  end
  it 'is valid with valid attributes' do
    expect(@blog).to be_valid
  end
  it 'is not valid without a title' do
    @blog.title = nil
    expect(@blog).to_not be_valid
  end

  it 'is not valid without body' do
    @blog.body =nil
    expect(@blog).to_not be_valid
  end
  
  it 'should belongs to User' do
    t = Blog.reflect_on_association(:user)
    expect(t.macro).to eq(:belongs_to)
  end

  it 'should has_many Blogview' do
    t = Blog.reflect_on_association(:blog_views)
    expect(t.macro).to eq(:has_many)
  end
end