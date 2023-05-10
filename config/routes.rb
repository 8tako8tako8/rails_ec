# frozen_string_literal: true

Rails.application.routes.draw do
  root 'products#index'
  resources :products, only: %i[show]
  resources :carts, only: %i[index]
  post 'carts/add-to-cart', to: 'carts#add_to_cart'
  delete 'carts/remove-from-cart', to: 'carts#remove_from_cart'
  resources :orders, only: %i[create index show]
  post 'promotion-codes/use', to: 'promotion_codes#use'
end
