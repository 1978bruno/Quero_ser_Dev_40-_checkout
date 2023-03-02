class Api::V1::OrdersController < ActionController::API
  def index
    if params[:customer_id].empty?
      return render json: { error: 'Documento do cliente não informado' }.to_json,
                    status: :not_found
    end

    orders = Order.where(customer_doc_ident: params[:customer_id], status: :pending)

    return render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found if orders.empty?

    render status: :ok, json: orders.as_json(except: %i[id cancel_reason created_at updated_at salesman_id],
                                             include: { salesman: { only: %i[id name email] } })
  rescue StandardError
    render json: { error: 'Ocorreu um erro interno' }.to_json, status: :internal_server_error
  end

  def paid
    @order = Order.find_by(id: params[:id])

    return render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found if @order.nil?

    @order.update(payment_mode: params[:payment_mode], discount: params[:discount])

    @order.paid!
    render status: :ok, json: @order.as_json(except: %i[id cancel_reason created_at updated_at salesman_id],
                                             include: { salesman: { only: %i[id name email] } })
  end

  def cancelled
    @order = Order.find_by(id: params[:id])
    return render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found if @order.nil?

    @order.update(status: :cancelled, cancel_reason: params[:cancel_reason])

    render status: :ok, json: @order.as_json(except: %i[id created_at updated_at salesman_id],
                                             include: { salesman: { only: %i[id name email] } })
  end
end
