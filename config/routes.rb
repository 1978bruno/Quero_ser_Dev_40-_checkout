Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :orders, only: %i[index] do
    member { post :cancel_order }
  end
end
