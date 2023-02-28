require 'rails_helper'

RSpec.describe CustomerService do
  describe '#get_customer' do
    it 'with success' do
      mocked_answer = double({ status: 200,
                               body: '{
                                "doc_ident":"87591438786",
                                "name":"José da Silva",
                                "email":"jose.silva@email.com.br",
                                "address":"Rua das Palmeiras, 100",
                                "city":"São Paulo",
                                "state":"SP",
                                "zipcode":"11111-111",
                                "phone":"11-99999-8888",
                                "birthdate":"1980-01-01",
                                "corporate_name":""
                                      }' })
      allow(Faraday).to receive(:get).and_return(mocked_answer)

      api_customer = CustomerService.get_customer('87591438786')

      expect(api_customer).to eq({ success: true, data: {
                                   doc_ident: '87591438786',
                                   name: 'José da Silva',
                                   email: 'jose.silva@email.com.br',
                                   address: 'Rua das Palmeiras, 100',
                                   city: 'São Paulo',
                                   state: 'SP',
                                   zipcode: '11111-111',
                                   phone: '11-99999-8888',
                                   birthdate: '1980-01-01',
                                   corporate_name: ''
                                 } })
    end

    it 'not found' do
      allow(Faraday).to receive(:get).and_return(double({ status: 404, body: '' }))

      api_customer = CustomerService.get_customer('11122233345')

      expect(api_customer).to eq({ success: false, data: {} })
    end

    it 'fail to access API' do
      allow(Faraday).to receive(:get).and_return(double({ status: 500 }))

      api_customer = CustomerService.get_customer('11122233345')
      expect(api_customer).to eq({ success: false,
                                   data: { status_message: 'Não foi possível acessar a API de clientes' } })
    end

    it 'return error from raised exceptions' do
      allow(Faraday).to receive(:get).and_raise(Faraday::TimeoutError)

      api_customer = CustomerService.get_customer('11122233345')

      expect(api_customer).to eq({ success: false, data: { status_message: 'timeout' } })
    end
  end
end
