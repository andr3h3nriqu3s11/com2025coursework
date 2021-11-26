require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @transaction = transactions(:one)
    @transaction2 = transactions(:two)
    @transaction3 = transactions(:three)

    @user = users(:one)
    @user2 = users(:two)
  end

  test "should not get index - no user" do
    get transactions_url
    assert_redirected_to new_user_session_url
  end

  test "should get index" do
     sign_in @user
     get transactions_url
     assert_response :success
     sign_out @user
   end


  test "should not get new - no login" do
    get new_transaction_url
    assert_redirected_to new_user_session_url
  end

  test "should get new" do
    sign_in @user
    get new_transaction_url
    assert_response :success
    sign_out @user
  end

  #
  # test "should create transaction" do
  #   assert_difference('Transaction.count') do
  #     post transactions_url, params: { transaction: { description: @transaction.description, destination: @transaction.destination, origin: @transaction.origin, value: @transaction.value } }
  #   end
  #
  #   assert_redirected_to transaction_url(Transaction.last)
  # end
  #

  test "should not show transaction - no login" do
    get transaction_url(@transaction)
    assert_redirected_to new_user_session_url
  end

  test "should not show transaction - does not exist" do
    sign_in @user
    get transaction_url(-1)
    assert_redirected_to transaction404_url
    sign_out @user
  end

  test "should not show transaction - wrong user" do
    sign_in @user2
    get transaction_url(@transaction)
    assert_redirected_to transaction404_url
    sign_out @user2
  end

  test "should show transaction - at least one origin or destination" do
    sign_in @user2
    get transaction_url(@transaction2)
    assert_response :success
    get transaction_url(@transaction3)
    assert_response :success
    sign_out @user2
  end

  test "should show transaction" do
    sign_in @user
    get transaction_url(@transaction)
    assert_response :success
    sign_out @user
  end

  test "should not show transaction404" do
    get transaction404_url
    assert_redirected_to new_user_session_url
  end

  test "should show transaction404" do
    sign_in @user
    get transaction404_url
    assert_response :success
    sign_out @user
  end

  test "should not get edit transaction - no login" do
    get edit_transaction_url(@transaction)
    assert_redirected_to new_user_session_url
  end

  test "should not get edit transaction - does not exist" do
    sign_in @user
    get edit_transaction_url(10000)
    assert_redirected_to transaction404_url
    sign_out @user
  end

  test "should not get edit transaction - wrong user" do
    sign_in @user2
    get edit_transaction_url(@transaction)
    assert_redirected_to transaction404_url
    sign_out @user2
  end

  test "should get edit transaction - at least one origin or destination" do
    sign_in @user2
    get edit_transaction_url(@transaction2)
    assert_response :success
    get edit_transaction_url(@transaction3)
    assert_response :success
    sign_out @user2
  end

  test "should get edit transaction" do
    sign_in @user
    get edit_transaction_url(@transaction)
    assert_response :success
    sign_out @user
  end

  test "should not destroy transaction - no user" do
    delete transaction_url(@transaction)
    assert_redirected_to new_user_session_url
  end

  test "should not destroy transaction - no user and not exists" do
    delete transaction_url(-1)
    assert_redirected_to new_user_session_url
  end

  test "should not destroy transaction - no not exists" do
    sign_in @user
    delete transaction_url(-1)
    assert_redirected_to transaction404_url
    sign_out @user
  end

  test "should not destroy transaction - wrong user" do
    sign_in @user2
    delete transaction_url(@transaction)
    assert_redirected_to transaction404_url
    sign_out @user2
  end

  test "should not destroy transaction - not origin" do
    sign_in @user2
    delete transaction_url(@transaction2)
    assert_redirected_to transaction_url(@transaction2)
    sign_out @user2
  end

  test "should destroy transaction" do
    sign_in @user
    assert_difference('Transaction.count', -1) do
      delete transaction_url(@transaction)
    end
    assert_redirected_to wallet_url(@transaction.origin.id)
    sign_out @user
    @transaction.save
  end
  #
  # test "should update transaction" do
  #   patch transaction_url(@transaction), params: { transaction: { description: @transaction.description, destination: @transaction.destination, origin: @transaction.origin, value: @transaction.value } }
  #   assert_redirected_to transaction_url(@transaction)
  # end
  #
end
