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
end
