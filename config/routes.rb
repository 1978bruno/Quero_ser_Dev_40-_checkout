Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :users_admin, controller: 'users' do
    patch 'lock_unlock', on: :member
    get 'edit_password', on: :member
    post 'update_password', on: :member
    get 'index_admin', on: :collection
  end
  resources :users, only: [:index]
  resources :orders, only: %i[index new show] do
    collection do
      get :prefil_order_form
    end
    member do
      patch :order_cancel_post
      get :order_cancel_reason
    end
  end

  resources :blacklisted_customers, only: %i[index destroy] do
    post 'save', on: :member
  end
end
