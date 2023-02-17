Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :orders, only: %i[index show] do
    member do
      post :order_cancel_post
      get  :order_cancel_reason
    end
  end
end
