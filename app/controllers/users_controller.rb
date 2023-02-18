class UsersController < ApplicationController
  def index
    @user_log = current_user.admin
    users_params = params["query"]
    if users_params.nil? && @user_log
      @users = User.where("active = true and admin = false")
    else
      @users = User.where("name like ? and active = true and admin = false", "%#{users_params}%")
    end
    if !@user_log
      @users = []
      @users << current_user
      flash.now[:notice] = "Não tem acesso. Precisa estar logado como Admin."
    end
  end
end