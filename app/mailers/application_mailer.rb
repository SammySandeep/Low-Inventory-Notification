class ApplicationMailer < ActionMailer::Base
  default from: ENV["SENDINBLUE_EMAIL"]
  layout 'mailer'
end
