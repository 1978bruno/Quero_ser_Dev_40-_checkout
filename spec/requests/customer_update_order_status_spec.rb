require 'rails_helper'

describe 'Order API' do
  context 'GET /api/v1/orders' do
    it 'atualiza status do pedido para pago' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      customer = create(:customer, doc_ident: '22200022201')
      order = create(:order, customer_id: customer.id, salesman_id: salesman.id,
                             product_plan_name: 'Hospedagem GO',
                             product_plan_periodicity: 'Mensal')
      create(:order, customer_id: customer.id, salesman_id: salesman.id,
                     product_plan_name: 'Hospedagem Premmium',
                     product_plan_periodicity: 'Anual')

      patch "/api/v1/orders/#{order.id}/set_paid"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('paid')
      expect(json_response['id']).to eq(order.id)
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it 'falha se o pedido não for encontrado' do
      patch '/api/v1/orders/999999/set_paid'

      expect(response.status).to eq 404
    end
  end
end
