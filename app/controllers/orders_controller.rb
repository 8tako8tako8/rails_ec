# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :basic_auth, only: %i[index show], if: -> { Rails.env.production? }

  def create
    return if cart_products_blank?(order_params, current_cart.cart_products)

    order_details = set_order_details
    begin
      order(order_params, order_details)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
      set_err_params_and_redirect(e.record.errors.full_messages, order_params)
    rescue StandardError
      set_err_params_and_redirect(['予期しないエラー'], order_params)
    end
  end

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD']
    end
  end

  def order_params
    params.require(:order).permit(
      :first_name, :last_name, :email, :prefecture, :address, :address2,
      :card_name, :card_number, :card_expiration_date, :card_cvv,
      :quantity, :total_price
    )
  end

  def set_order_details
    order_details = []
    current_cart.cart_products.each do |cart_product|
      order_details << {
        product_sku: cart_product.product.sku,
        product_name: cart_product.product.name,
        unit_price: cart_product.product.price,
        quantity: cart_product.quantity
      }
    end
    order_details
  end

  def order(request_order, request_order_details)
    ApplicationRecord.transaction { register_order(request_order, request_order_details) }
    OrderMailer.order_confirm(request_order, request_order_details).deliver_now
    flash[:notice] = '購入ありがとうございます'
    redirect_to root_path
  end

  def register_order(request_order, request_order_details)
    order = create_order(request_order)
    request_order_details.each do |order_detail|
      create_order_detail(order, order_detail[:product_sku], order_detail[:product_name], order_detail[:unit_price], order_detail[:quantity])
    end
    current_cart.destroy!
  end

  def create_order(order)
    Order.create(
      first_name: order[:first_name], last_name: order[:last_name],
      email: order[:email], prefecture: order[:prefecture],
      address: order[:address], address2: order[:address2],
      card_name: order[:card_name], card_number: order[:card_number],
      card_expiration_date: order[:card_expiration_date], card_cvv: order[:card_cvv],
      total_price: order[:total_price]
    )
  end

  def create_order_detail(order, product_sku, product_name, unit_price, quantity)
    order.order_details.create!(
      product_sku: product_sku,
      product_name: product_name,
      unit_price: unit_price,
      quantity: quantity
    )
  end

  def cart_products_blank?(request_order, cart_products)
    if cart_products.blank?
      @order = Order.new(request_order)
      flash.now[:error_messages] = ['カートが空です']
      render 'carts/index', status: :unprocessable_entity
      return true
    end
    false
  end

  def set_err_params_and_redirect(messages, request_order)
    @order = Order.new(request_order)
    flash.now[:error_messages] = messages
    render 'carts/index', status: :unprocessable_entity
  end
end
