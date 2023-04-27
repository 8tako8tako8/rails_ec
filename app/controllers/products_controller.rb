class ProductsController < ApplicationController
  def index
    @tasks = Product.all
  end
end
