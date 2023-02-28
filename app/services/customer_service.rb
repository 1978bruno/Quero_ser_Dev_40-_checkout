class CustomerService
  class << self
    def get_customer(customer_doc_ident)
      response = Faraday.get("#{Rails.configuration.external_apis['customer_api_url']}/#{customer_doc_ident}")
      return { success: false, data: {} } if response.status == 404
      if response.status != 200 || !check_response(response)
        return { success: false, data: { status_message: 'Não foi possível acessar a API de clientes' } }
      end

      customer = JSON.parse(response.body)
      { success: true, data: { name: customer['name'],
                               doc_ident: customer['identification'], email: customer['email'] } }
    rescue StandardError => e
      { success: false, data: { status_message: e.message } }
    end

    def save_customer(_customer_data)
      { success: true, data: {} }
    end

    private

    def check_response(response)
      response.body.include?('name') && response.body.include?('identification') && response.body.include?('email')
    end
  end
end
