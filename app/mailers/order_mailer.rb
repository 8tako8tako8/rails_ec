class OrderMailer < ApplicationMailer
  def order_confirm(order, order_details)
    @order = order
    @order_details = order_details
    if order[:email].present?
      mail(to: order[:email], subject: '注文完了のお知らせ')
      logger.info "++#{order[:email]}"
    end
  end
end
