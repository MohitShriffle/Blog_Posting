# frozen_string_literal: true

every 1.day, at: '4:30 am' do
  runner 'ExpirationNotificationJob.perform_async'
end
