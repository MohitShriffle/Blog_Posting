class UserMailer < ApplicationMailer
  def welcome_email
    @user=params[:user]
    byebug
    mail(to: @user.email, subject: "Welcome To My Webside!")
  end
end
