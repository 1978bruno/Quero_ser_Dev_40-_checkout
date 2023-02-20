Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :users_admin, :controller => 'users' do
    get 'edit_password', on: :member
    post 'update_password', on: :member
  end
end
