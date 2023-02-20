class UsersController < ApplicationController
  def index
    if current_user.admin == false
      @users = []
      @users << current_user
      flash.now[:notice] = 'Não tem acesso. Precisa estar logado como Admin.'
    elsif params['query'].nil?
      @users = User.where('active = true and admin = false')
    else
      @users = User.where('name like ? and active = true and admin = false', "%#{params['query']}%")
    end
  end
end
