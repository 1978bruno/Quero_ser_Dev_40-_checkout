class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.admin? ? Order.all : current_user.orders
  end

  def show
  end
end
