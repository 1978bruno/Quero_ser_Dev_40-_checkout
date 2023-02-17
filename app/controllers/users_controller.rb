class UsersController < ApplicationController
  before_action :authenticate_user!, :redirect_unless_admin, only: [:index]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_admin_index_path, notice: 'Usuário cadastrado com sucesso'
    else
      render :new
    end
  end

  private

  def redirect_unless_admin
    return if current_user.try(:admin?)

    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :admin)
  end
end
