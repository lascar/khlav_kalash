json.extract! order, :id, :quantity, :first_name, :last_name, :country, :email_address, :number, :permalink, :created_at, :updated_at
json.url order_url(order, format: :json)
