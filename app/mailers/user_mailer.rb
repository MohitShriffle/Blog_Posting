# frozen_string_literal: true

# UserMailer class
class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome To My Webside!')
  end

  def sent_otp_email(user)
    @user = user
    mail(to: @user.email, subject: 'Varification With Otp Email')
  end

  def expiration_notification(user)
    @user = user
    mail(to: @user.email, subject: 'Subscription Expiration Notification')
  end
end
