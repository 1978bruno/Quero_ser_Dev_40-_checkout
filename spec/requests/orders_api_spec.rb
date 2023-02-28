require 'rails_helper'

describe 'Order API' do
  context 'GET /api/v1/orders' do
    it 'successo' do
      salesman = create(:user, email: 'user@locaweb.com.br', password: '12345678', admin: false)
      customer = create(:customer, doc_ident: '22200022201')
      create(:order, customer_id: customer.id, salesman_id: salesman.id,
                     product_plan_name: 'Hospedagem GO',
                     product_plan_periodicity: 'Mensal')
      create(:order, customer_id: customer.id, salesman_id: salesman.id,
                     product_plan_name: 'Hospedagem Premmium',
                     product_plan_periodicity: 'Anual')

      post '/api/v1/orders/list_by_doc', params: { doc_ident: customer.doc_ident }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response[0]['product_plan_name']).to eq 'Hospedagem GO'
      expect(json_response[0].keys).not_to include('created_at')
      expect(json_response[0].keys).not_to include('updated_at')
    end

    it 'falha se não houver pedidos' do
      post '/api/v1/orders/list_by_doc', params: { doc_ident: '999999999' }

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Nenhum registro encontrado'
    end

    it 'falha se não for informado o documento' do
      post '/api/v1/orders/list_by_doc', params: { doc_ident: '' }

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Documento do cliente não informado'
    end

    it 'e existe um erro interno' do
      allow(Order).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      post '/api/v1/orders/list_by_doc', params: { doc_ident: '22200022201' }

      expect(response).to have_http_status(500)
    end
  end
end
