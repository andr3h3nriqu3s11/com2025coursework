require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

  setup do
    @wallet =  wallets(:one)
    @wallet2 =  wallets(:one)
  end

  test "should not create - no origin" do
    t = Transaction.new

    t.destination = @wallet2
    t.value = 1

    refute t.save
  end

  test "should not create - no destination" do
    t = Transaction.new

    t.origin = @wallet
    t.value = 1

    refute t.save
  end

  test "should not create - invalid origin" do
    t = Transaction.new

    t.origin_id = -1
    t.destination = @wallet2
    t.value = 1

    refute t.save
  end

  test "should not create - invalid destination" do
    t = Transaction.new

    t.origin = @wallet
    t.destination_id = -1
    t.value = 1

    refute t.save
  end

  test "should not create - no value" do
    t = Transaction.new

    t.origin = @wallet
    t.destination = @wallet2

    refute t.save
  end

  test "should create - no description" do
    t = Transaction.new

    t.origin = @wallet
    t.destination = @wallet2
    t.value = 1

    assert t.save
  end

  test "should create" do
    t = Transaction.new

    t.origin = @wallet
    t.destination = @wallet2
    t.value = 1

    assert t.save
  end

end
