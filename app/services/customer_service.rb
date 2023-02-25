class CustomerService
  class << self
    def get_customer(customer_doc_ident)
      response = Faraday.get("#{ENV.fetch('CUSTOMER_API_URL')}/#{customer_doc_ident}")
      return nil if response.status == 404
      if response.status != 200 || !check_response(response)
        return { erro: 'Não foi possível acessar a API de clientes' }
      end

      customer = JSON.parse(response.body)
      { name: customer['name'], doc_ident: customer['identification'], email: customer['email'] }
    rescue StandardError => e
      { erro: e.message }
    end

    private

    def check_response(response)
      response.body.include?('name') && response.body.include?('identification') && response.body.include?('email')
    end
  end
end
