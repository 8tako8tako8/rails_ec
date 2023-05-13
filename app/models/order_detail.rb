# frozen_string_literal: true

class OrderDetail < ApplicationRecord
  belongs_to :order

  validates :product_sku, presence: true
  validates :product_name, presence: true
  validates :unit_price, presence: true
  validates :quantity, presence: true

  def self.create_order_details(cart_products)
    order_details = []
    cart_products.each do |cart_product|
      order_details << OrderDetail.new(
        product_sku: cart_product.product.sku,
        product_name: cart_product.product.name,
        unit_price: cart_product.product.price,
        quantity: cart_product.quantity
      )
    end
    order_details
  end
end
