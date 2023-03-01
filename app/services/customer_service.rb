class CustomerService
  class << self
    def get_customer(customer_doc_ident)
      response = Faraday.get("#{Rails.configuration.external_apis['customer_api_url']}/#{customer_doc_ident}")

      return ResponseHelper.not_found('Cliente não encontrado') if response.status == 404

      if response.status != 200 || !check_response(response)
        return ResponseHelper.error('Não foi possível acessar a API de clientes')
      end

      customer = JSON.parse(response.body, symbolize_names: true)
      ResponseHelper.success(customer)
    rescue StandardError => e
      ResponseHelper.error(e.message)
    end

    def save_customer(_customer_data)
      { success: true, data: {} }
    end

    private

    def check_response(response)
      response.body.include?('name') && response.body.include?('doc_ident') && response.body.include?('email')
    end

    def convert_customer(customer)
      { doc_ident: customer['doc_ident'], name: customer[:name],
        email: customer['email'], address: customer[:address],
        city: customer['city'], state: customer[:state],
        zipcode: customer['zipcode'], phone: customer[:phone],
        birthdate: customer['birthdate'], corporate_name: customer[:corporate_name] }
    end
  end
end
