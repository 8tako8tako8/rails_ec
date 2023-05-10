class OrderMailer < ApplicationMailer
  def order_confirm(order)
    @order = order
<<<<<<< HEAD
    @order_details = order_details
    mail(to: order[:email], subject: '注文完了のお知らせ')
    end
=======
    @order_details = order[:order_details]
    logger.info "++b++"
    mail(to: order[:email], subject: '注文完了のお知らせ')
>>>>>>> de21677de71c1bdb146e0f5f43809c6bbded0b42
  end
end
