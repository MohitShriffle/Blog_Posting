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
  
  def daily_blog_views_report(csv_data)
    attachments['daily_blog_views_report.csv'] = csv_data
    mail(to: 'mohitkumravat22@gmail.com', subject: 'Daily Blog Views Report')
  end

end



