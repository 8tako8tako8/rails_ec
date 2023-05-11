# frozen_string_literal: true

namespace :promotion_code do
  desc 'プロモーションコード10個生成'
  task generate: :environment do
    count = 0
    while count < 10
      code = generate_code
      discount_amount = generate_discount_amount.to_i
      promotion_code = PromotionCode.create(code: code, discount_amount: discount_amount, is_used: false)
      next if promotion_code.nil?

      count += 1
    end
    puts 'Promotion codes generated successfully'
  end

  def generate_code
    charset = ('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a
    7.times.map { charset.sample }.join
  end

  def generate_discount_amount
    (100..1000).step(100).to_a.sample
  end
end
