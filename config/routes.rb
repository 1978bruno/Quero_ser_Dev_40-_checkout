Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :orders, only: %i[index show] do
    member { post :cancel_order }
  end
end
