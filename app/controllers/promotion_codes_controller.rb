# frozen_string_literal: true

class PromotionCodesController < ApplicationController
  def use
    promotion_code = PromotionCode.find_by(code: params[:code])
    return err_params_and_render(['無効なプロモーションコードです']) if promotion_code.nil?
    return err_params_and_render(['プロモーションコードを利用できるのは１回限りです']) unless current_cart.promotion_code.nil?
    return err_params_and_render(['既に使用済みのプロモーションコードです']) if promotion_code.is_used?
    return err_params_and_render(['カートが空です']) if current_cart.cart_products.empty?

    begin
      apply_promotion_code(promotion_code)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved => e
      err_params_and_render(e.record.errors.full_messages)
    rescue StandardError
      err_params_and_render(['予期しないエラー'])
    end
  end

  private

  def apply_promotion_code(promotion_code)
    ApplicationRecord.transaction { current_cart.apply_promotion_code!(promotion_code) }
    flash.now[:notice] = 'プロモーションコードが適用されました'
    render 'carts/index', status: :unprocessable_entity
  end

  def err_params_and_render(messages)
    @order = Order.new
    flash.now[:error_messages] = messages
    render 'carts/index', status: :unprocessable_entity
  end
end
