# frozen_string_literal: true

class OrderDetail < ApplicationRecord
  belongs_to :order

  validates :product_sku, presence: true
  validates :product_name, presence: true
  validates :unit_price, presence: true
  validates :quantity, presence: true

  def self.create_order_details(cart_products)
    cart_products.map do |cart_product|
      OrderDetail.new(
        product_sku: cart_product.product.sku,
        product_name: cart_product.product.name,
        unit_price: cart_product.product.price,
        quantity: cart_product.quantity
      )
    end
  end
end
