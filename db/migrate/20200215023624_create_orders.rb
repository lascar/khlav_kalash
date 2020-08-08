class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :quantity
      t.string :first_name
      t.string :last_name
      t.string :street_line_1
      t.string :street_line_2
      t.string :postal_code
      t.string :region
      t.string :city
      t.string :country
      t.string :email_address
      t.string :number
      t.string :permalink

      t.timestamps
    end

    add_index :orders, :number, unique: true
    add_index :orders, :permalink, unique: true
  end
end
