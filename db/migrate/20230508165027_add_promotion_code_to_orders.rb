# frozen_string_literal: true

class AddPromotionCodeToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :promotion_code, foreign_key: true, optional: true
  end
end
