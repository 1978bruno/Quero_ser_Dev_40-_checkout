class Api::V1::OrdersController < ActionController::API
  def list_by_doc
    if params[:doc_ident].empty?
      return render json: { error: 'documento do cliente não informado' }.to_json,
                    status: :not_found
    end

    customer_by_doc = Customer.find_by(doc_ident: params[:doc_ident])
    orders = Order.where(customer_id: customer_by_doc, status: :pending)
    return render json: { error: 'nenhum registro encontrado' }.to_json, status: :not_acceptable if orders.empty?

    render status: :ok, json: orders
  rescue StandardError
    render json: { error: 'Ocorreu um erro interno' }.to_json, status: :internal_server_error
  end
end
