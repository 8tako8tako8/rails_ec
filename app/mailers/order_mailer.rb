class OrderMailer < ApplicationMailer
  def order_confirm(order, order_details)
    @order = order
    @order_details = order_details
    mail(to: 'example@example.com', subject: '注文完了のお知らせ')
  end
end
