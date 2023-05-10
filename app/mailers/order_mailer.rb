class OrderMailer < ApplicationMailer
  def order_confirm(order)
    @order = order
    @order_details = order[:order_details]
    logger.info "++b++"
    if order[:email].present?
      mail(to: order[:email], subject: '注文完了のお知らせ').deliver_now
      logger.info "++c++"
    end
  end
end
