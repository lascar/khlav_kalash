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

  test "first name mandatory" do
    order = orders(:without_first_name)
    assert_not order.valid?
  end

  test "country mandatory" do
    order = orders(:without_country)
    assert_not order.valid?
  end

  test "postal code mandatory" do
    order = orders(:without_postal_code)
    assert_not order.valid?
  end

  test "email address mandatory" do
    order = orders(:without_email_address)
    assert_not order.valid?
  end

  test "quantity mandatory" do
    order = orders(:without_quantity)
    assert_not order.valid?
  end

end
