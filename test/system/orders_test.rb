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
      visit new_order_url

      fill_in "Quantity", with: @order.quantity
      select(ISO3166::Country['es'].name, from: "order_country").select_option
      fill_in "Email address", with: @order.email_address
      fill_in "First name", with: @order.first_name
      fill_in "Last name", with: @order.last_name
      fill_in "Postal code", with: @order.postal_code
      click_on "Create Order"
      click_on "Confirm Order"
      fill_in('email', with: 'toto@example.com')
      fill_in('cardNumber', with: '4242424242424242')
      # fill_in('cardNumber', with: '4000000000003220')
      fill_in('cardExpiry', with: '1221')
      fill_in('cardCvc', with: '123')
      fill_in('billingName', with: 'toto')
      within "#billingCountry" do
        find("option[value='FR']").click
      end
      find('.SubmitButton').click
      sleep 5
      assert_equal(page.current_path.sub(/\..*/, ""), "/order/" + Order.last.permalink)
      assert_equal(find('#amount_paid').text,
                          "€" + (ENV['UNIT_PRICE_CENTS'].to_i * 2 / 100.0).to_s)
  end

  test "updating a Order" do
    visit orders_url.sub(/http:\/\//, "http://admin:password@")
    click_on "Edit", match: :first

    fill_in "Quantity", with: @order.quantity
    select(ISO3166::Country['es'].name, from: "order_country").select_option
    fill_in "Email address", with: @order.email_address
    fill_in "First name", with: @order.first_name
    fill_in "Last name", with: @order.last_name
    fill_in "Postal code", with: @order.postal_code
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
