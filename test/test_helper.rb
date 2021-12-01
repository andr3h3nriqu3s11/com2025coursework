ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  setup do
    # These is needed since the the characters on the wallet icons are stored there
    # Not needed since I put the ones that are needed for the test to pass on the fixtures
    #Rails.application.load_seed
  end

  # Add more helper methods to be used by all tests here...
  #
  def check_header_login
    assert_select "nav" do |elms|
      assert_equal 1, elms.length
    end

    assert_select "nav ul" do |elms|
      assert_equal 1, elms.length

      elms.each do |e|
        e.children.each do |c|
          if c.name == "li"
            c.children.each do |cOfc|
              if cOfc.name == "a" and cOfc.attr("href") == edit_user_registration_path
                assert true
                return
              end
            end
          end
        end
      end
    end
    # if it gets here then you have an error
    assert false
  end

  def check_header
    assert_select "nav"
    assert_select "nav" do |elms|
      assert_equal 1, elms.length
    end

    assert_select "nav ul" do |elms|
      assert_equal 1, elms.length

      elms.each do |e|
        e.children.each do |c|
          if c.name == "li"
            c.children.each do |cOfc|
              if cOfc.name == "a" and cOfc.attr("href") == edit_user_registration_path
                # if it gets here then you have an error
                # If we are not login then the profile part should not appear
                assert false
              end
            end
          end
        end
      end
    end
    # Everything is fine
    assert true

  end

end
