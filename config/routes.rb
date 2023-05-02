# frozen_string_literal: true

Rails.application.routes.draw do
  resources :products, only: %i[index show]
  resources :carts, only: %i[index]
  post 'carts/add-to-cart', to: 'carts#add_to_cart'
  delete 'carts/remove-from-cart', to: 'carts#remove_from_cart'
end
