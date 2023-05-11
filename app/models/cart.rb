# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :cart_products, dependent: :destroy
  belongs_to :promotion_code, optional: true

  def total_quantity
    cart_products.sum(:quantity)
  end

  def total_price
    each_prices = cart_products.map do |cart_product|
      cart_product.product.price * cart_product.quantity
    end
    if promotion_code.nil?
      each_prices.sum
    elsif (each_prices.sum - promotion_code.discount_amount) <= 0
      0
    else
      each_prices.sum - promotion_code.discount_amount
    end
  end
end
