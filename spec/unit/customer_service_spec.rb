require 'rails_helper'

RSpec.describe CustomerService do
  describe '#get_customer' do
    it 'with success' do
      mocked_answer = double({ status: 200,
                               body: '{
                                        "name": "PINEAPLE LTDA",
                                        "identification": "11122233345",
                                        "email": "contato@pineaple.com.br"
                                      }' })
      allow(Faraday).to receive(:get).and_return(mocked_answer)

      api_customer = CustomerService.get_customer('11122233345')

      expect(api_customer).to eq({
                                   name: 'PINEAPLE LTDA',
                                   doc_ident: '11122233345',
                                   email: 'contato@pineaple.com.br'
                                 })
    end

    # it 'not found' do
    #   allow(Faraday).to receive(:get).and_return(double({ status: 200, body: '' }))

    #   api_customer = CustomerService.get_customer('11122233345')
    #   abrir formulario de cadastro...(teste não unitário)

    #   expect(api_customer).to eq('')
    # end

    it 'fail to access API' do
      allow(Faraday).to receive(:get).and_return(double({ status: 500 }))

      api_customer = CustomerService.get_customer('11122233345')
      expect(api_customer).to eq({ erro: 'Não foi possível acessar a API de clientes' })
    end

    it 'return error from raised exceptions' do
      allow(Faraday).to receive(:get).and_raise(Faraday::TimeoutError)

      api_customer = CustomerService.get_customer('11122233345')

      expect(api_customer).to eq({ erro: 'timeout' })
    end
  end
end
