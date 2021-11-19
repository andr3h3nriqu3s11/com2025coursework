require 'test_helper'

class ContactMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "submit mail" do

    mail = ContactMailer.contact_email("test@test.test", "test", "Test", "Test test")

    assert_equal [I18n.t('email.support')], mail.to
    assert_equal [I18n.t('email.no_reply')], mail.from
    assert_equal ['test@test.test'], mail.cc
    assert_equal 'Test', mail.subject
  end
end
