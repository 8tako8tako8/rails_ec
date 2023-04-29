# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
if Rails.env.development?
  (1..10).each do |i|
    product = Product.new(name: "商品#{i}", price: 1000)
    file_path = Rails.root.join('db/seeds/sample.jpg')
    file = File.open(file_path)
    product.image.attach(io: file, filename: 'sample.jpg', content_type: 'image/jpeg')
    product.save
  end
end

if Rails.env.production?
  (1..10).each do |i|
    product = Product.new(name: "商品#{i}", price: 1000)
    file_path = Rails.root.join('db/seeds/sample.jpg')
    file = File.open(file_path)
    product.image.attach(io: file, filename: 'sample.jpg', content_type: 'image/jpeg')
    product.save
  end
end
