require 'rails_helper'

describe 'Order API' do
  context 'GET /api/v1/orders' do
    it 'atualiza status do pedido para pago' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      order = create(:order, salesman_id: salesman.id, customer_doc_ident: '22200022201',
                             product_plan_name: 'Hospedagem GO', product_plan_periodicity: 'Mensal',
                             price: 30.00)
      create(:order, salesman_id: salesman.id, customer_doc_ident: '22200022201',
                     product_plan_name: 'Hospedagem Premmium', product_plan_periodicity: 'Anual')

      post "/api/v1/customers/orders/#{order.order_code}/paid", params: { payment_mode: 'credit_card',
                                                                          discount: 10.99 }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('paid')
      expect(json_response['order_code']).to eq(order.order_code)
      expect(json_response['payment_mode']).to eq('credit_card')
      expect(json_response['discount']).to eq('10.99')
      expect(json_response['paid_at']).not_to eq(nil)
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it 'falha se o pedido não for encontrado' do
      post '/api/v1/customers/orders/999999/paid'

      expect(response.status).to eq 404
    end

    it 'falha se não for informado o modo de pagamento' do
      post '/api/v1/customers/orders/9qeZ77Gih8/paid', params: { payment_mode: '' }

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Modo de pagamento não informado'
    end

    it 'e existe um erro interno' do
      allow(Order).to receive(:find_by).and_raise(ActiveRecord::QueryCanceled)

      post '/api/v1/customers/orders/9qeZ77Gih8/paid', params: { payment_mode: 'credit_card',
                                                                 discount: 10.99 }

      expect(response).to have_http_status(500)
    end
  end
end
