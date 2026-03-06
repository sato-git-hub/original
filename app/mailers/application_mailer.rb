class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@flaag.net"
  
  layout "mailer"
end
