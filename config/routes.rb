Rails.application.routes.draw do
  root to: 'orders#new'

  resources :orders
  post 'order/pay', to: 'orders#pay', as: :order_pay
  get 'order/confirm', to: 'orders#confirm', as: :order_confirm
  get 'order/cancel', to: 'orders#cancel', as: :order_cancel
  get 'order/:permalink', to: 'orders#permalink', as: :order_permalink
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
