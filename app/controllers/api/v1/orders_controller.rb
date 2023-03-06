class Api::V1::OrdersController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_internal_error
  rescue_from ActiveRecord::RecordNotFound, with: :return_not_found
  before_action :if_payment_params_is_empty, only: [:paid]
  before_action :if_cancel_reason_param_is_empty, only: [:cancelled]

  def index
    orders = Order.where(customer_doc_ident: params[:customer_id], status: :pending)

    return render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found if orders.empty?

    render status: :ok, json: orders.as_json(except: %i[id cancel_reason created_at updated_at salesman_id],
                                             include: { salesman: { only: %i[name email] } })
  end

  def paid
    @order = Order.find_by(order_code: params[:id])
    return render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found if @order.nil?

    @order.update(payment_mode: params[:payment_mode], discount: params[:discount], paid_at: Time.current)
    @order.paid!
    PaidCommission.pay_commission_from_order_code(@order.order_code)
    render status: :ok, json: @order.as_json(except: %i[id cancel_reason created_at updated_at salesman_id],
                                             include: { salesman: { only: %i[name email] } })
  end

  def cancelled
    @order = Order.find_by(order_code: params[:id])
    return render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found if @order.nil?

    @order.update(status: :cancelled, cancel_reason: params[:cancel_reason])

    render status: :ok, json: @order.as_json(except: %i[id created_at updated_at salesman_id],
                                             include: { salesman: { only: %i[name email] } })
  end

  private

  def if_payment_params_is_empty
    return if params[:payment_mode].present?

    render json: { error: 'Modo de pagamento não informado' }.to_json,
           status: :not_found
  end

  def if_cancel_reason_param_is_empty
    return if params[:cancel_reason].present?

    render json: { error: 'Motivo do cancelamento não informado' }.to_json,
           status: :not_found
  end

  def return_internal_error
    render json: { error: 'Ocorreu um erro interno' }.to_json, status: :internal_server_error
  end

  def return_not_found
    render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found
  end
end
