# frozen_string_literal: true

class AddSkuAndDescriptionToProducts < ActiveRecord::Migration[7.0]
  def change
    change_table :products, bulk: true do |t|
      t.string :sku
      t.text :description
    end
  end
end
