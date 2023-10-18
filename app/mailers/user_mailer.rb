# frozen_string_literal: true

# UserMailer class
class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome To My Webside!')
  end
end
