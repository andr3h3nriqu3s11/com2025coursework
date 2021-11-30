class ContactController < ApplicationController
  def contact
  end

  # This method send the email using the contact mailler
  def submit
    name = params[:name]
    email = params[:email]
    subject = params[:subject]
    message = params[:message]

    if email.blank?
      flash[:alert] = I18n.t('form.messages.no_email')
    elsif name.blank?
      flash[:alert] = I18n.t('form.messages.no_name')
    elsif subject.blank?
      flash[:alert] = I18n.t('form.messages.no_subject')
    else
      flash[:notice] = I18n.t('contact.messages.sent')
      ContactMailer.contact_email(email, name, subject, message)
    end
    redirect_to contact_path
  end
end
