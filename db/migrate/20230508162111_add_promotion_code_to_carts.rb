class AddPromotionCodeToCarts < ActiveRecord::Migration[7.0]
  def change
    add_reference :carts, :promotion_code, foreign_key: true, optional: true
  end
end
