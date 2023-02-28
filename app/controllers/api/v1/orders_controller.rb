class Api::V1::OrdersController < ActionController::API
  def list_by_doc
    if params[:doc_ident].empty?
      return render json: { error: 'Documento do cliente não informado' }.to_json,
                    status: :not_found
    end

    orders = Order.where(customer_doc_ident: params[:doc_ident], status: :pending)
    return render json: { response: 'Nenhum registro encontrado' }.to_json, status: :not_found if orders.empty?

    render status: :ok, json: orders.as_json(except: %i[created_at updated_at])
  rescue StandardError
    render json: { error: 'Ocorreu um erro interno' }.to_json, status: :internal_server_error
  end
end
