class Api::V1::OrdersController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_internal_error
  rescue_from ActiveRecord::RecordNotFound, with: :return_not_found
  before_action :if_payment_params_is_empty, only: [:pay]
  before_action :if_cancel_reason_param_is_empty, only: [:cancel]

  def list_by_customer
    orders = Order.pending_or_awaiting.where(customer_doc_ident: params[:customer_id])

    return render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found if orders.empty?

    render status: :ok, json: orders.as_json(except: %i[id cancel_reason salesman_id],
                                             include: { salesman: { only: %i[name email] } })
  end

  def pay
    @order = Order.find_by(order_code: params[:id])
    return render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found if @order.nil?

    @order.update!(payment_mode: params[:payment_mode], discount: params[:discount], paid_at: Time.current)
    @order.paid!
    render status: :ok, json: @order.as_json(except: %i[id cancel_reason salesman_id],
                                             include: { salesman: { only: %i[name email] } })
  end

  def cancel
    @order = Order.find_by(order_code: params[:id])
    return render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found if @order.nil?

    @order.update!(status: :cancelled, cancel_reason: params[:cancel_reason])

    render status: :ok, json: @order.as_json(except: %i[id salesman_id],
                                             include: { salesman: { only: %i[name email] } })
  end

  def awaiting_payment
    @order = Order.find_by(order_code: params[:id])
    return render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found if @order.nil?

    @order.update!(status: :awaiting_payment)

    render status: :ok, json: @order.as_json(except: %i[id salesman_id],
                                             include: { salesman: { only: %i[name email] } })
  end

  def renew
    @order = Order.find_by(order_code: params[:id])
    return render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found if @order.nil?

    # @order.update(status: :cancelled, cancel_reason: params[:cancel_reason])

    # render status: :ok, json: @order.as_json(except: %i[id salesman_id],
    #                                          include: { salesman: { only: %i[name email] } })
  end

  private

  def if_payment_params_is_empty
    return if params[:payment_mode].present?

    render json: { error: 'Modo de pagamento não informado' }.to_json,
           status: :bad_request
  end

  def if_cancel_reason_param_is_empty
    return if params[:cancel_reason].present?

    render json: { error: 'Motivo do cancelamento não informado' }.to_json,
           status: :bad_request
  end

  def return_internal_error
    render json: { error: 'Ocorreu um erro interno' }.to_json, status: :internal_server_error
  end

  def return_not_found
    render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found
  end
end
