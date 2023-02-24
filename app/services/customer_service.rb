class CustomerService
  class << self
    def get_customer(customer_doc_ident)
      begin
        response_api = Faraday.get("#{ENV['CUSTOMER_API_URL'] || 'http://localhost:3001'}/#{customer_doc_ident}")
      rescue StandardError
        return { erro: 'Não foi possível acessar a API de clientes' }
      end

      return nil if response_api.status == 404
      if response_api.status != 200 || !check_response(response_api)
        return { erro: 'Não foi possível acessar a API de clientes' }
      end

      { nome: response_api.body.nome, doc_ident: response_api.body.identification, email: response_api.body.email }
    end

    private

    def check_response(response)
      response.body.include?(:nome) && response.body.include?(:identification) && response.body.include?(:email)
    end
  end
end
