Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :users_admin, :controller => 'users' do
    patch 'lock_unlock', on: :member
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

  namespace :api do
    namespace :v1 do
      resources :orders, only: [:index] do
        collection do
          post  :list_by_doc
        end
        member do
          patch  :set_paid
        end
      end
    end
  end
end
