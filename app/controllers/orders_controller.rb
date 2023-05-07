class OrdersController < ApplicationController

  def create
    ApplicationRecord.transaction do
      request_orders = order_params
      order = create_order(request_orders)
      request_orders[:order_details].each do |order_detail|
        create_order_detail(order, order_detail)
      end
      current_cart.destroy!
    end
  end
  
  private

  def order_params
    params.require(:order).permit(
      :first_name,
      :last_name,
      :email,
      :prefecture,
      :address,
      :address2,
      :card_name,
      :card_number,
      :card_expiration_date,
      :card_cvv,
      :quantity,
      :total_price,
      order_details:[
        :product_name,
        :product_sku,
        :quantity,
        :unit_price
      ]
    )
  end
  
  def create_order(order)
    Order.create!(
      first_name: order[:first_name],
      last_name: order[:last_name],
      email: order[:email],
      prefecture: order[:prefecture],
      address: order[:address],
      address2: order[:address2],
      card_name: order[:card_name],
      card_number: order[:card_number],
      card_expiration_date: order[:card_expiration_date],
      card_cvv: order[:card_cvv],
      total_price: order[:total_price]
    )
  end

  def create_order_detail(order, order_detail)
    order.order_details.create!(
      product_sku: order_detail[:product_sku],
      product_name: order_detail[:product_name],
      unit_price: order_detail[:unit_price],
      quantity: order_detail[:quantity]
    )
  end
end
