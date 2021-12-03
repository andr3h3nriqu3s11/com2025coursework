require 'test_helper'

class QuickLinkTest < ActiveSupport::TestCase

  setup do
    @wallet =  wallets(:one)
    @wallet2 =  wallets(:one)
  end

  test "should not create - no origin" do
    t = QuickLink.new

    t.destination = @wallet2
    t.name= "t"

    refute t.save
  end

  test "should not create - no destination" do
    t = QuickLink.new

    t.origin = @wallet
    t.name= "t"

    refute t.save
  end

  test "should not create - invalid origin" do
    t = QuickLink.new

    t.origin_id = -1
    t.destination = @wallet2
    t.name = "t"

    refute t.save
  end

  test "should not create - invalid destination" do
    t = QuickLink.new

    t.origin = @wallet
    t.destination_id = -1
    t.name = "t"

    refute t.save
  end

  test "should not create - no name" do
    t = QuickLink.new

    t.origin = @wallet
    t.destination = @wallet2

    refute t.save
  end

  test "should create" do
    t = QuickLink.new

    t.origin = @wallet
    t.destination = @wallet2
    t.name = "test"

    assert t.save
  end

end
