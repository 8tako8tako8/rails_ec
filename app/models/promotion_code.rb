# frozen_string_literal: true

class PromotionCode < ApplicationRecord
  validates :code, presence: true
  validates :discount_amount, presence: true
end
