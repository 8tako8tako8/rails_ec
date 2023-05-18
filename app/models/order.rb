# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_details, dependent: :destroy
  belongs_to :promotion_code, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :prefecture, presence: true
  validates :address, presence: true
  validates :address2, presence: true
  validates :card_name, presence: true
  validates :card_number, presence: true, length: { minimum: 14, maximum: 16 }
  validates :card_expiration_date, presence: true
  validates :card_cvv, presence: true, length: { minimum: 3, maximum: 4 }
  validates :total_price, presence: true
end
