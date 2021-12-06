require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = users(:one)
  end

  test "Should not create" do
    refute User.new.save
  end

  test "Should not create - no email" do
    u = User.new
    u.password = "test1234"
    refute u.save
  end

  test "Should not create - no password" do
    u = User.new
    u.email = "test@test.test"
    refute u.save
  end

  test "should create" do
    u = User.new
    u.email = "test@test.test"
    u.password = "test1234"
    assert u.save

    assert u.user_type == "normal"

  end

  test "should not create - unsafe password" do
    u = User.new
    u.email = "test@test.test"
    u.password = "test"
    refute u.save
  end

  test "should not create - non existent user type" do
    u = User.new
    u.email = "test@test.test"
    u.password = "test"
    assert_raise do
      u.user_type = 3
    end
  end

  test "should delete user" do

    assert_difference "User.count", -1 do
      assert_difference "Wallet.count", -2 do
        assert_difference "Transaction.count", -3 do
          assert_difference "QuickLink.count", -3 do
            @user.destroy
          end
        end
      end
    end
  end

end
