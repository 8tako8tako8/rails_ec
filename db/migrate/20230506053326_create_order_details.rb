# frozen_string_literal: true

class CreateOrderDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :order_details do |t|
      t.string :product_sku, null: false
      t.string :product_name, null: false
      t.decimal :unit_price, null: false
      t.integer :quantity, null: false
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
