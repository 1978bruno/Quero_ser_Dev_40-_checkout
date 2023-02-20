Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :users_admin, :controller => 'users' do
    get 'edit_password', on: :member
    post 'update_password', on: :member
    get 'index_admin', on: :collection
  end
  resources :users, only: [:index]
  resources :orders, only: %i[index show] do
    member do
      patch :order_cancel_post
      get  :order_cancel_reason
    end
  end
end
