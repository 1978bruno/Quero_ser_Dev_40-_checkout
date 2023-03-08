class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :retrieve_id, only: %i[show order_cancel_reason order_cancel_post]

  def index
    @orders = if current_user.admin?
                Order.all.page params[:page]
              else
                current_user.orders.page params[:page]
              end
  end

  def show
    @api_result = CustomerService.get_customer(@order.customer_doc_ident)

    if @api_result[:status] == 'SUCCESS'
      @customer = @api_result[:data]
    else
      @customer = {}
      flash[:alert] = @api_result[:status_message] if @api_result[:status] == 'ERROR_API'
      flash[:notice] = @api_result[:status_message] if @api_result[:status] == 'NOT_FOUND'
    end
  end

  def new; end

  def order_cancel_post
    @order.cancel_reason = params[:order][:cancel_reason]
    @order.cancelled!
    @order.save
    redirect_to orders_path, notice: "Ordem #{@order.order_code} cancelada"
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = 'O motivo do cancelamento precisa ser preenchido'
    render :order_cancel_reason and return
  end

  def order_cancel_reason; end

  private

  def retrieve_id
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: I18n.t(:not_found)
  end
end
