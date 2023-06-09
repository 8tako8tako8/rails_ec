# frozen_string_literal: true

class CartsController < ApplicationController
  def index
    @order = Order.new
  end

  def add_to_cart
    product_id = params[:product_id]
    quantity = params[:quantity].to_i
    cart_product = current_cart.cart_products.find_by(product_id: product_id)
    if cart_product
      cart_product.quantity += quantity
      cart_product.save!
    else
      current_cart.cart_products.create!(product_id: product_id, quantity: quantity)
    end
    redirect_to carts_path
  end

  def remove_from_cart
    cart_product = CartProduct.find_by(cart_id: current_cart.id, product_id: params[:product_id])
    cart_product.destroy
    redirect_to carts_path
  end

  private

  def order_params
    params.require(:order).permit(
      :first_name, :last_name, :email, :prefecture, :address, :address2,
      :card_name, :card_number, :card_expiration_date, :card_cvv,
      :quantity, :total_price
    )
  end
end
