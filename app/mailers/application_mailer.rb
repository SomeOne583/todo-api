class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.gmail_mail
  layout 'mailer'
end
