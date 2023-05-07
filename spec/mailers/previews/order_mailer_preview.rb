class OrderMailerPreview < ActionMailer::Preview
  def order_confirm
    order = Order.new(
      first_name: 'test',
      last_name: 'test',
      email: 'example@example.com',
      prefecture: '東京都',
      address: '渋谷区東',
      address2: '1-1-1',
      card_name: 'TARO TANAKA',
      card_number: '1111111111111111',
      card_expiration_date: '2701',
      card_cvv: '111',
      total_price: 4000
    )
    order_details = [
      {product_name: "商品1", product_sku: "example1", quantity: 2, unit_price: 1000},
      {product_name: "商品2", product_sku: "example2", quantity: 1, unit_price: 2000}
    ]
    OrderMailer.order_confirm(order, order_details)
  end
end
