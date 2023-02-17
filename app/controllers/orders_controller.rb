class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :retrieve_id, only: %i[order_cancel_reason]

  def index
    @orders = current_user.admin? ? Order.all : current_user.orders
  end

  def show; end

  def order_cancel_post
    @order = Order.find(params[:id])
    @order.cancel_reason = params[:order][:cancel_reason]
    @order.cancelled!
    @order.save
    # redirect_to orders_path, notice: "Ordem #{@order.code} cancelada" and return if @order.save

    # redirect_to orders_path, alert: I18n.t(:cant_cancel_order) and return
    redirect_to orders_path, notice: "Ordem #{@order.order_code} cancelada"
  end

  def order_cancel_reason; end

  private

  def retrieve_id
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: I18n.t(:not_found)
  end
end
