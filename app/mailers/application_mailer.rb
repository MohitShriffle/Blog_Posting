# frozen_string_literal: true

# ApplicationMailer class
class ApplicationMailer < ActionMailer::Base
  default from: 'mohitk@shriffle.com'
  layout 'mailer'
end
