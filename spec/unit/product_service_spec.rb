require 'rails_helper'

RSpec.describe ProductService do
  describe '#list_products' do
    it 'list with product' do
      mocked_answer = double({ status: 200,
                               body: '{ "products": [{ "plan_name": "Hospedagem GO",
                                                    "periodicity": "Anual",
                                                    "price": 9.90 }] }' })

      allow(Faraday).to receive(:get).and_return(mocked_answer)

      produtos_listados = ProductService.list_products
      expect(produtos_listados).to eq([{ product_plan_name: 'Hospedagem GO',
                                         product_plan_periodicity: 'Anual',
                                         price: 9.90 }])
    end

    it 'empty list' do
      allow(Faraday).to receive(:get).and_return(double({ status: 200, body: '{ "products":[] }' }))

      produtos_listados = ProductService.list_products

      expect(produtos_listados).to eq([])
    end

    it 'fail to access API' do
      allow(Faraday).to receive(:get).and_return(double({ status: 500 }))

      produtos_listados = ProductService.list_products

      expect(produtos_listados).to eq({ erro: 'Não foi possível acessar a API de produtos' })
    end

    it 'return error from raised exceptions' do
      allow(Faraday).to receive(:get).and_raise(Faraday::TimeoutError)

      produtos_listados = ProductService.list_products

      expect(produtos_listados).to eq({ erro: 'timeout' })
    end
  end
end
