require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
  end

  test "should get home" do
    get root_url
    assert_response :success

    check_header

    #This checks if the scale has all of the requirements for it to look good
    assert_select "#balance" do |bals|
      #There should only be one scale on the home screen
      assert_equal 1, bals.length
      bar_count = 0;
      bals.each do |bal|
        bal.children.each do |bar|
          # Ignore anything that isn't a bar
          if bar.attr("id") == "bar"
            bar_count = 1
            text = false
            icon1 = false
            icon2 = false
            count = 0;

            #Check for the rest of the requirements that are inside the bar
            bar.children.each do |c|
              if c.attr("class").nil?
                next
              end
              if c.attr("class").include? "text"
                text = true
                count += 1;
              elsif c.attr("class").include? "icon1"
                icon1 = true
                count += 1;
              elsif c.attr("class").include? "icon2"
                icon2 = true
                count += 1;
              end
            end

            assert_equal 3, count

            assert text and icon1 and icon2
          end
        end
      end

      #There should only be one element inside the #balance that has the bar id
      assert_equal 1, bar_count

    end
  end

  test "should redirect to dashboard" do
    sign_in @user

    get root_url
    assert_redirected_to dashboard_url

    sign_out @user
  end

end
