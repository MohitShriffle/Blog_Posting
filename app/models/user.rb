# frozen_string_literal: true

# user class
class User < ApplicationRecord
  has_secure_password
  belongs_to :subscription, optional: true
  has_many :post
  # has_one_attached :profile_picture
  validates :email, uniqueness: true
  validates :email, presence: true
  validates :name, :user_name, :type, presence: true
  validate  :validate_email
  # before_save :generate_otp_1

  def validate_email
    return unless (email =~ /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/).nil?

    errors.add(:email, 'please enter a valid email')
  end

  # def generate_and_send_otp
  #   otp = rand(1000..9999).to_s
  #   update(otp: otp)
  #   UserMailer.send_otp(self).deliver_now
  # end

  def generate_otp!
    self.otp = generate_token
    self.otp_sent_at = Time.now.utc
    save!
  end

  def otp_valid?
    (otp_sent_at + 4.hours) > Time.now.utc
  end

  def reset_otp!(_password)
    self.otp = nil
    # self.password = password
    # save!
  end

  private

  def generate_otp
    SecureRandom.hex(6)
  end
end
