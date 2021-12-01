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

     check_header_login

     #Checks that all the transactions from that user are shown
     assert_select ".transactionLineItem" do |elms|
       # We remove one for the header line which has the same selector of the rest of the lines
       assert_equal Transaction.by_user(@user).length, elms.length - 1
     end

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

    check_header_login

    sign_out @user
  end

  test "should not create transaction - no user" do
    assert_difference('Transaction.count', 0) do
      post transactions_url, params: { transaction: { description: @transaction.description, destination_id: @transaction.destination_id, origin_id: @transaction.origin_id, value: @transaction.value } }
    end
    assert_redirected_to new_user_session_url
  end

  test "should not create transaction - no origin_id" do
    sign_in @user
    assert_difference('Transaction.count', 0) do
      post transactions_url, params: { transaction: { description: @transaction.description, destination_id: @transaction.destination_id, value: @transaction.value } }
    end
    assert_redirected_to new_transaction_url
    sign_out @user
  end

  test "should not create transaction - no destination_id" do
    sign_in @user
    assert_difference('Transaction.count', 0) do
      post transactions_url, params: { transaction: { description: @transaction.description, origin_id: @transaction.origin_id, value: @transaction.value } }
    end

    assert_redirected_to new_transaction_url
    sign_out @user
  end

  test "should not create transaction - origin_id not owned" do
    sign_in @user2
    assert_difference('Transaction.count', 0) do
      post transactions_url, params: { transaction: { description: @transaction.description, destination_id: @transaction.destination_id, origin_id: @transaction.origin_id, value: @transaction.value } }
    end
    assert_redirected_to new_transaction_url
    sign_out @user2
  end

  test "should not create transaction - no value" do
    sign_in @user
    assert_difference('Transaction.count', 0) do
      post transactions_url, params: { transaction: { description: @transaction.description, destination_id: @transaction.destination_id, origin_id: @transaction.origin_id } }
    end

    assert_response :unprocessable_entity
    sign_out @user
  end

  test "should create transaction - no description" do
    sign_in @user
    assert_difference('Transaction.count') do
      post transactions_url, params: { transaction: { destination_id: @transaction.destination_id, origin_id: @transaction.origin_id, value: @transaction.value } }
    end

    assert_redirected_to transaction_url(Transaction.last)
    sign_out @user
  end

  test "should create transaction" do
    sign_in @user
    assert_difference('Transaction.count') do
      post transactions_url, params: { transaction: { description: @transaction.description, destination_id: @transaction.destination_id, origin_id: @transaction.origin_id, value: @transaction.value } }
    end

    assert_redirected_to transaction_url(Transaction.last)
    sign_out @user
  end

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

    check_header_login

    get transaction_url(@transaction3)
    assert_response :success

    check_header_login

    sign_out @user2
  end

  test "should show transaction" do
    sign_in @user

    get transaction_url(@transaction)
    assert_response :success

    check_header_login

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

    check_header_login

    get edit_transaction_url(@transaction3)
    assert_response :success

    check_header_login

    sign_out @user2
  end

  test "should get edit transaction" do
    sign_in @user

    get edit_transaction_url(@transaction)
    assert_response :success

    check_header_login

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

  test "should not update transaction - no user" do
    patch transaction_url(@transaction), params: { transaction: { description: @transaction.description, destination_id: @transaction.destination_id, origin_id: @transaction.origin_id, value: @transaction.value } }
    assert_redirected_to new_user_session_url
  end

  test "should not update transaction - origin_id not owned" do
    sign_in @user2
    patch transaction_url(@transaction), params: { transaction: { description: @transaction.description, destination_id: @transaction.destination_id, origin_id: @transaction.origin_id, value: @transaction.value } }
    assert_redirected_to transaction404_url
    sign_out @user2
  end

  test "should update transaction" do
    sign_in @user
    patch transaction_url(@transaction), params: { transaction: { description: @transaction.description, destination_id: @transaction.destination_id, origin_id: @transaction.origin_id, value: @transaction.value } }
    assert_redirected_to transaction_url(Transaction.last)
    sign_out @user
  end

end
