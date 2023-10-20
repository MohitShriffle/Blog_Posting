# frozen_string_literal: true

# user class
class User < ApplicationRecord
  has_secure_password
  has_one  :subscription
  # belongs_to :plan
  has_many :blogs
  has_one_attached :profile_picture
  validates :email, uniqueness: true
  validates :email, presence: true
  validates :name, :user_name, :type, presence: true
  validate  :validate_email
  # before_create :generate_otp

  def validate_email
    return unless (email =~ /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/).nil?

    errors.add(:email, 'please enter a valid email')
  end

  def reset_otp!
    update(otp: generate_otp)
    update(otp_sent_at: Time.now.utc)
  end

  def otp_valid?
    (otp_sent_at + 4.hours) > Time.now.utc
  end

  def complete_verification
    update(verified: true)
    update(otp: nil)
  end

  def generate_otp
    '%06d' % rand(6**6)
  end
end
