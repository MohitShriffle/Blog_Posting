FactoryBot.define do
  factory :blog_view do
    viewed_at {Time.now}
    blog{FactoryBot.create(:blog)}
    user{FactoryBot.create(:user)}
  end
end
