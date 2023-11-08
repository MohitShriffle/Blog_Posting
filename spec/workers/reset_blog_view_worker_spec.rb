require 'rails_helper'
RSpec.describe ResetBlogViewWorker,type: :worker do 
  let(:blog_view){ FactoryBot.create(:blog_view) } 
  describe "perform" do
    context "Testing reset Blog view Worker" do
      it "it reset BlogView" do
        ResetBlogViewWorker.new.perform
        expect((BlogView.all).count).to eq(0)
      end
    end
  end
end