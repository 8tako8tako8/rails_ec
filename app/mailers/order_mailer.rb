class OrderMailer < ApplicationMailer
  def order_confirm(order, order_details)
    @order = order
    @order_details = order_details
    mail(to: order[:email], subject: '注文完了のお知らせ')
    end
  end
end
