class Api::V1::OrdersController < ActionController::API
  def list_by_doc
    customer_by_doc = Customer.find_by(doc_ident: params[:doc_ident])
    orders = Order.where(customer_id: customer_by_doc)

    render status: 200,json: orders
  end
end



