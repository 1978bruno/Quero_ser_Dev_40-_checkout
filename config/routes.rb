Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  
  resources :users_admin, :controller => 'users'
  # do
    # post 'update_password', on: :member
    # get 'edit_password', on: :member
  # end

end
