require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test "email with good format" do
    order = orders(:one)
    assert order.valid?
  end

  test "email with wrong format" do
    order = orders(:bad_email)
    assert_not order.valid?
  end

end
