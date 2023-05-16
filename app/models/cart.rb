# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :cart_products, dependent: :destroy
  belongs_to :promotion_code, optional: true

  def total_quantity
    cart_products.sum(:quantity)
  end

  def total_price
    each_prices = cart_products.map { |cart_product| cart_product.product.price * cart_product.quantity }
    discounted_price = each_prices.sum - (promotion_code&.discount_amount || 0)
    [discounted_price, 0].max
  end

  def apply_promotion_code!(promotion_code)
    update!(promotion_code: promotion_code)
    promotion_code.update!(is_used: true)
  end
end
