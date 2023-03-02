require 'rails_helper'

describe 'Order API' do
  context 'GET /api/v1/orders' do
    it 'atualiza status do pedido para cancelado' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      order = create(:order, salesman_id: salesman.id, customer_doc_ident: '22200022201',
                             product_plan_name: 'Hospedagem GO', product_plan_periodicity: 'Mensal',
                             price: 30.00)
      create(:order, salesman_id: salesman.id, customer_doc_ident: '22200022201',
                     product_plan_name: 'Hospedagem Premmium', product_plan_periodicity: 'Anual')

      post "/api/v1/customers/orders/#{order.id}/cancelled", params: { cancel_reason: 'O cliente desistiu' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('cancelled')
      expect(json_response['order_code']).to eq(order.order_code)
      expect(json_response['cancel_reason']).to eq('O cliente desistiu')
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it 'falha se o pedido não for encontrado' do
      post '/api/v1/customers/orders/999999/cancelled'

      expect(response.status).to eq 404
    end
  end
end
