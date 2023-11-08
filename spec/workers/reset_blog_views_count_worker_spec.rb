require 'rails_helper'
RSpec.describe ResetBlogViewsCountWorker,type: :worker do  
  describe "perform" do
    context "Testing Blog view count Worker" do
      it 'resets blog_views_count for all users to 0' do
        user1 = FactoryBot.create(:user,blog_views_count: 10)
        user2 = FactoryBot.create(:user,blog_views_count: 5)
        user3 = FactoryBot.create(:user,blog_views_count: 7)
        ResetBlogViewsCountWorker.new.perform
        user1.reload
        user2.reload
        user3.reload
        expect(user1.blog_views_count).to eq(0)
        expect(user2.blog_views_count).to eq(0)
        expect(user3.blog_views_count).to eq(0)
      end
    end
  end
end













