require 'csv'
class DailyBlogViewsReportWorker 
  include Sidekiq::Worker
  def perform
    users_and_blogs = find_users_and_blogs_with_five_views
    csv_data = generate_csv(users_and_blogs)
    send_email_with_csv(csv_data)
  end

  private
   
  def find_users_and_blogs_with_five_views
    BlogView.where(blog_id: BlogView.group(:blog_id).having('COUNT(blog_id) = ?', 5).pluck(:blog_id))
  end

  def generate_csv(users_and_blogs)
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['User ID', 'Blog ID', 'Viewed_at']

      users_and_blogs.each do |view|
        csv << [view.user_id, view.blog_id, view.viewed_at]
      end
    end
    filename = "/home/hp/Desktop/csv/daily_blog_views_report #{Date.today}.csv"
    File.open(filename, 'w') { |file| file.write(csv_data) }
    csv_data  
  end

  def send_email_with_csv(csv_data)
    UserMailer.daily_blog_views_report(csv_data).deliver_now
  end
end
