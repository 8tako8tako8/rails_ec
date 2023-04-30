# frozen_string_literal: true

class ChangeProductsNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :products, :name, false
    change_column_null :products, :price, false
  end
end
