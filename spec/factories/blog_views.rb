FactoryBot.define do
  factory :blog_view do
    viewed_at {Time.now}
    blog
    user
  end
end
