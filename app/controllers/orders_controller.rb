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

    if customer_search.blank?
      flash.now[:alert] = 'Deve ser informado um número de documento'
      render :new
    end
    customer_search = customer_search.gsub(/[^0-9]/, '')
    blacklisted_customer = BlacklistedCustomer.find_by(doc_ident: customer_search)
    if blacklisted_customer.nil?
      flash.now[:alert] = 'Este cliente está bloqueado'
      render :new
    end
    customer_api = CustomerService.get_customer(customer_search)
    redirect_to new_customer_path if customer_api.nil?
    if customer_api.include?(:erro)
      flash.now[:alert] = 'Problema de acesso à base de dados'
      render :new
    end
    products = ProductService.list_products
    if products.include?(:erro)
      flash.now[:alert] = 'Problema de acesso à lista de produtos'
      render :new
    end
    render :new, locals: { customer: customer_api, products: }
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
