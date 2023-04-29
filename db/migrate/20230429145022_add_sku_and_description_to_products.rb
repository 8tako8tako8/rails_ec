class AddSkuAndDescriptionToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :sku, :string
    add_column :products, :description, :text
  end
end
