class PromotionCodesController < ApplicationController
  def use
    ApplicationRecord.transaction do
      promotion_code = PromotionCode.find_by(code: params[:code])
      if !current_cart.promotion_code.nil?
        flash[:alert] = 'プロモーションコードを利用できるのは１回限りです'
      elsif promotion_code.nil?
        flash[:alert] = '無効なプロモーションコードです'
      elsif promotion_code.is_used?
        flash[:alert] = '既に使用済みのプロモーションコードです'
      elsif current_cart.cart_products.empty?
        flash[:alert] = 'カートが空です'
      else
        current_cart.update!(promotion_code: promotion_code)
        promotion_code.update!(is_used: true)
        flash[:notice] = 'プロモーションコードが適用されました'
      end
    end 
    redirect_to carts_path
  end
end