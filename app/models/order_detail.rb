class OrderDetail < ApplicationRecord
  belongs_to :order

  validates :product_sku, presence: true
  validates :product_name, presence: true
  validates :unit_price, presence: true
  validates :quantity, presence: true
end
