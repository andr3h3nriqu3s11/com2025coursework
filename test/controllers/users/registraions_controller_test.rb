require 'test_helper'

class ContactControllerTest < ActionDispatch::IntegrationTest

  # Only this test is being done since it was the only controller action that I changed from the
  # the default devise ones
  test "create new user" do
    assert_difference "Wallet.count", 3 do
      # The root path is the same as the users path see the routes file and the base path has been
      # set to "" which makes it the root path
      post root_path, params: { user: {
        email: "email@email.eamil",
        password: "testtest",
        password_repeat: "testtest"
      }}
    end

    assert_redirected_to root_url
  end

end
