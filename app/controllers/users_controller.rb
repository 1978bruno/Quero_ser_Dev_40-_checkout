class UsersController < ApplicationController
  before_action :authenticate_user!, :redirect_unless_admin, only: [:index]
  before_action :set_user, only: %i[edit update]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_admin_index_path, notice: I18n.t('user.msg_record_created')
    else
      render :new
    end
  end

  def update
    user_params_edit = if params[:user][:password].blank?
                         params.require(:user).permit(:email, :name, :admin)
                       else
                         params.require(:user).permit(:email, :name, :password, :password_confirmation, :admin)
                       end

    if @user.update(user_params_edit)
      redirect_to users_admin_index_path, notice: I18n.t('user.msg_user_changed')
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def redirect_unless_admin
    return if current_user.try(:admin?)

    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :admin)
  end
end
