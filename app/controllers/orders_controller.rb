class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :retrieve_id, only: %i[order_cancel_reason order_cancel_post]

  def index
    @orders = current_user.admin? ? Order.all : current_user.orders
  end

  def show; end

  def new; end

  def prefil_order_form
    customer_search = params[:customer_ident]
    # # pesquis no blocked list (model scope blocked)
    # # flash.now[:alert] = 'Cliente bloqueado'
    # # render :new 
    # customeApiResponse = CustomerService.get_customer(customer_search)
    # if (customeApiResponse.nil?)
      # redirect_to cadastrar novo cliente
    # if customeApiResponse.include?(:erro)
    #   flash.now[:alert] = 'Cliente bloqueado'
      # render :new 

    # # if true render new with alert usuario bloqueado
    # # chama service cliente
    # # if error in response render new with msg
    # # if nil redirect to cadastro 
    # # servico de produtos
    # products = ProductsService.list_products()
    # render :new, locals: { customer: customer_search, products: products }
    # flash.now[:alert] = 'Cliente bloqueado'
  end


  def order_cancel_post
    @order.cancel_reason = params[:order][:cancel_reason]
    @order.cancelled!
    @order.save
    redirect_to orders_path, notice: "Ordem #{@order.order_code} cancelada"
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = 'O motivo do cancelamento precisa ser preenchido'
    render :order_cancel_reason
  end

  def order_cancel_reason; end

  private

  def retrieve_id
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: I18n.t(:not_found)
  end
end
