# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :cart_products, dependent: :destroy

  def total_quantity
    cart_products.sum(:quantity)
  end

  def total_price
    each_prices = cart_products.map do |cart_product|
      cart_product.product.price * cart_product.quantity
    end
    each_prices.sum
  end
end
