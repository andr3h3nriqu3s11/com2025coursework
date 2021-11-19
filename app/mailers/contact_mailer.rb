class ContactMailer < ApplicationMailer

  def contact_email(email, name, subject, message)
    @email = email;
    @name = name;
    @subject = subject;
    @message = message;

    mail to: I18n.t('email.support'), cc: @email, subject: subject
  end

end
