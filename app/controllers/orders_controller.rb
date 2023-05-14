# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :basic_auth, only: %i[index show], if: -> { Rails.env.production? }

  def create
    order = Order.new(order_params)
    return set_err_params_and_render(['カートが空です'], order) if current_cart.cart_products.blank?

    order_details = OrderDetail.create_order_details(current_cart.cart_products)
    begin
      order(order, order_details)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
      set_err_params_and_render(e.record.errors.full_messages, order)
    rescue StandardError
      set_err_params_and_render(['予期しないエラー'], order)
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

  def order(order, order_details)
    ApplicationRecord.transaction { register_order(order, order_details) }
    OrderMailer.order_confirm(order, order_details).deliver_now
    flash[:notice] = '購入ありがとうございます'
    redirect_to root_path
  end

  def register_order(order, order_details)
    order.order_details = order_details
    order.save!
    current_cart.destroy!
  end

  def set_err_params_and_render(messages, order)
    @order = order
    flash.now[:error_messages] = messages
    render 'carts/index', status: :unprocessable_entity
  end
end
