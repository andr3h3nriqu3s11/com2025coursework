class ContactController < ApplicationController
  def contact
  end

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
      flash[:notice] = I18n.t('contact.messages.message_sent')
    end
    redirect_to contact_path
  end
end
