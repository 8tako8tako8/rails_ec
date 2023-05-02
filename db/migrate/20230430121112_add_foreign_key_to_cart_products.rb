class AddForeignKeyToCartProducts < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :cart_products, :carts
    add_foreign_key :cart_products, :products
  end
end
