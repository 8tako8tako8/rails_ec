# frozen_string_literal: true

class CartsController < ApplicationController
  def index
    
  end

  def add_to_cart
    cart_product = current_cart.cart_products.find_by(product_id: params[:product_id])
    if cart_product
      cart_product.quantity += params[:quantity].to_i
      cart_product.save!
    else
      current_cart.cart_products.create!(product_id: params[:product_id], quantity: params[:quantity])
    end
    redirect_to carts_path
  end

end
