# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :prefecture, null: false
      t.string :address, null: false
      t.string :address2, null: false
      t.string :card_name, null: false
      t.string :card_number, null: false
      t.string :card_expiration_date, null: false
      t.string :card_cvv, null: false
      t.decimal :total_price, null: false

      t.timestamps
    end
  end
end
