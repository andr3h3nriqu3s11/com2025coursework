# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

  def contact_email
    ContactMailer.contact_email("test@andr3h3nriqu3s.com", "Tester", "This is a test", "Of the preview functionality")
  end
end
