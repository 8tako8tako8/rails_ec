# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :basic_auth, only: %i[index show], if: -> { Rails.env.production? }

  def create
    request_order = order_params
    if request_order[:order_details].blank?
      redirect_to request.referer, flash: { order: request_order, alert: 'カートが空です' }
      return
    end
    ApplicationRecord.transaction { register_order(request_order) }
    OrderMailer.order_confirm(request_order).deliver_now if request_order[:email].present?
    flash[:notice] = '購入ありがとうございます'
    redirect_to root_path
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
      :quantity, :total_price,
      order_details: %i[product_name product_sku quantity unit_price]
    )
  end

  def register_order(request_order)
    order = create_order(request_order, current_cart.promotion_code)
    request_order[:order_details].each do |order_detail|
      create_order_detail(order, order_detail)
    end
    current_cart.destroy!
  end

  def create_order(order, promotion_code)
    Order.create!(
      first_name: order[:first_name], last_name: order[:last_name],
      email: order[:email], prefecture: order[:prefecture],
      address: order[:address], address2: order[:address2],
      card_name: order[:card_name], card_number: order[:card_number],
      card_expiration_date: order[:card_expiration_date], card_cvv: order[:card_cvv],
      total_price: order[:total_price], promotion_code: promotion_code
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
