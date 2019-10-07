class ApplicationMailer < ActionMailer::Base
  default from: ENV["send_email"]
  layout "mailer"
end
