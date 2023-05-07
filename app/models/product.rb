# frozen_string_literal: true

class Product < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true
  validates :price, presence: true
  validates :image, presence: true
  validates :sku, presence: true, uniqueness: true
end
