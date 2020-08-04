require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url.sub(/http:\/\//, "http://admin:password@")
    assert_selector "h1", text: "Orders"
  end

  test "creating a Order" do
    visit orders_url.sub(/http:\/\//, "http://admin:password@")
    click_on "New Order"

    fill_in "Amount cents", with: @order.amount_cents
    fill_in "Country", with: @order.country
    fill_in "Email address", with: @order.email_address
    fill_in "First name", with: @order.first_name
    fill_in "Last name", with: @order.last_name
    fill_in "Number", with: @order.number
    fill_in "Permalink", with: @order.permalink
    click_on "Create Order"

    assert_text "Order was successfully created"
    click_on "Back"
  end

  test "updating a Order" do
    visit orders_url.sub(/http:\/\//, "http://admin:password@")
    click_on "Edit", match: :first

    fill_in "Amount cents", with: @order.amount_cents
    select(ISO3166::Country['es'].name, from: "order_country").select_option
    fill_in "Email address", with: @order.email_address
    fill_in "First name", with: @order.first_name
    fill_in "Last name", with: @order.last_name
    click_on "Update Order"
    assert_text "Order was successfully updated"
    click_on "Back"
  end

  test "destroying a Order" do
    visit orders_url.sub(/http:\/\//, "http://admin:password@")
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Order was successfully destroyed"
  end
end
