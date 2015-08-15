Rails.application.routes.draw do
  resources :carts
  get 'store/index'
  resources :products

  root :to => 'store#index', :as => 'store'
end
