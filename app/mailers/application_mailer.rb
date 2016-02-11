class ApplicationMailer < ActionMailer::Base
  # can't use env here
  default from: "samtherubydeveloper@gmail.com"
  layout 'mailer'
end
