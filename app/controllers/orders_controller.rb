class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :retrieve_id, only: %i[order_cancel_reason order_cancel_post]

  def index
    @orders = current_user.admin? ? Order.all : current_user.orders
  end

  def show; end

  def new; end

  def prefil_order_form
    customer_search = clear_search_data(params[:customer_ident])

    invalid_customer_msg = error_from_search_data(customer_search)
    return render_new_with_alert(invalid_customer_msg) unless invalid_customer_msg.nil?

    customer_api = CustomerService.get_customer(customer_search)
    redirect_to new_customer_path if customer_api.nil?
    return render_new_with_alert('Problema de acesso à base de dados') if customer_api.include?(:erro)

    products = ProductService.list_products
    return render_new_with_alert('Problema de acesso à base de dados') if products.include?(:erro)

    render :new, locals: { customer: customer_api, products: }
  end

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

  def error_from_search_data(customer_search)
    return 'Deve ser informado um número de documento' if customer_search.blank?

    blacklisted_customer = BlacklistedCustomer.find_by(doc_ident: customer_search)
    return 'Este cliente está bloqueado' unless blacklisted_customer.nil?
  end

  def render_new_with_alert(msg)
    flash.now[:alert] = msg
    render :new
  end

  def clear_search_data(search_data)
    return search_data.gsub(/[^0-9]/, '') unless search_data.nil?

    search_data
  end
end
