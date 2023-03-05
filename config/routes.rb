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

  resources :creation_orders, only: %i[new create]
  resources :blocklisted_customers, only: %i[index destroy] do
    post 'save', on: :member
  end

  resources :paid_commissions, only: [:index] do
    get :salesman, on: :collection
  end

  namespace :api do
    namespace :v1 do
      resources :customers, only: [:show] do
        resources :orders, only: [:index]
      end
      resource :customers, only: [:index] do
        resources :orders, only: [:show] do
          post :paid, on: :member
          post :cancelled, on: :member
        end
      end
    end
  end
end
