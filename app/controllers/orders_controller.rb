class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    # @orders = current_user.is_admin? ? Orders.all : current_user.orders
    @orders = Order.all
  end
end
