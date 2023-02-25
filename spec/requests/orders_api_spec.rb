require 'rails_helper'

describe 'Order API' do
  context 'GET /api/v1/orders' do
    it 'success' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      customer = create(:customer, doc_ident: '22200022201')
      create(:order, customer_id: customer.id, salesman_id: salesman.id,
             product_plan_name: 'Hospedagem GO',
             product_plan_periodicity: 'Mensal')
      create(:order, customer_id: customer.id, salesman_id: salesman.id,
             product_plan_name: 'Hospedagem Premmium',
             product_plan_periodicity: 'Anual')

      post '/api/v1/orders/list_by_doc', params: { doc_ident: customer.doc_ident }

      expect(response.status).to eq 200;
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
    end 
  end
end
