# frozen_string_literal: true

# user class
class User < ApplicationRecord
  paginates_per 2
  has_secure_password
  has_one :subscription, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_many :blogviews, dependent: :destroy, class_name: 'BlogView'
  belongs_to :plan, optional: true

  has_one_attached :profile_picture

  validates :password,format:{with: /\A
    (?=.{6,})          # Must contain 6 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x}

  validates :name, :user_name,:email, presence: true
  validates :email, format: { with: /\A[^@\s]+@gmail\.com\z/i },uniqueness: true, unless: lambda{ email.blank? }
  
  def can_view_blog(blog)
    return true if BlogView.where(blog:, viewed_at: 24.hours.ago..Time.now).count < 5

    false
  end

  def reset_otp
    update(otp: generate_otp)
    update(otp_sent_at: Time.now.utc)
  end

  def otp_valid
    byebug
    (otp_sent_at + 4.hours) > Time.now.utc
  end

  def complete_verification
    update(verified: true)
    update(otp: nil)
  end

  def generate_otp
    '%06d' % rand(6**6)
  end

  def views_count_within_24_hours
    blog_views.where('viewed_at >= ? AND viewed_at <= ?', Time.now - 24.hours, Time.now).count
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at email id name otp otp_sent_at password_digest subscription_id type
       updated_at user_name verified]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[blogs blogviews plan profile_picture_attachment profile_picture_blob subscription]
  end
end
