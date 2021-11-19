class ApplicationMailer < ActionMailer::Base
  default from: I18n.t('email.no_reply')
  layout 'mailer'
end
