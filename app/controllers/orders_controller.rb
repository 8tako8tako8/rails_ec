# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :basic_auth, only: %i[index show], if: -> { Rails.env.production? }

  def create
    return if order_details_blank?(order_params)

    request_order = order_params.except(:order_details)
    begin
      order(order_params)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
      set_err_params_and_redirect(e.record.errors.full_messages, request_order)
    rescue StandardError
      set_err_params_and_redirect(['予期しないエラー'], request_order)
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
      :quantity, :total_price,
      order_details: %i[product_name product_sku quantity unit_price]
    )
  end

  def order(order_params)
    ApplicationRecord.transaction { register_order(order_params) }
    OrderMailer.order_confirm(order_params).deliver_now if order_params[:email].present?
    flash[:notice] = '購入ありがとうございます'
    redirect_to root_path
  end

  def register_order(request_order)
    order = create_order(request_order)
    request_order[:order_details].each do |order_detail|
      create_order_detail(order, order_detail)
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

  def create_order_detail(order, order_detail)
    order.order_details.create!(
      product_sku: order_detail[:product_sku],
      product_name: order_detail[:product_name],
      unit_price: order_detail[:unit_price],
      quantity: order_detail[:quantity]
    )
  end

  def order_details_blank?(order_params)
    if order_params[:order_details].blank?
      @order = Order.new(order_params)
      flash.now[:error_messages] = ['カートが空です']
      render 'carts/index'
      return true
    end
    false
  end

  def set_err_params_and_redirect(messages, request_order)
    @order = Order.new(request_order)
    flash.now[:error_messages] = messages
    render 'carts/index'
  end
end
