class ChangeProductsSkuUnique < ActiveRecord::Migration[7.0]
  def change
    add_index :products, :sku, unique: true
    change_column_null :products, :sku, false
  end
end
