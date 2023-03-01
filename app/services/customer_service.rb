require_relative 'response_helper'

class CustomerService
  class << self
    def get_customer(customer_doc_ident)
      response = Faraday.get("#{Rails.configuration.external_apis['customer_api_url']}/#{customer_doc_ident}")

      return Response.not_found('Cliente não encontrado') if response.status == 404

      if response.status != 200 || !check_response(response)
        return Response.error('Não foi possível acessar a API de clientes')
      end

      customer = JSON.parse(response.body, symbolize_names: true)
      Response.success(customer)
    rescue StandardError => e
      Response.error(e.message)
    end

    def save_customer(customer_data)
      response = Faraday.post(Rails.configuration.external_apis['customer_api_url'],
                              customer_data.to_json, { 'Content-Type' => 'application/json' })

      return Response.error('Não foi possível cadastrar o cliente') if response.status != 201

      Response.success(JSON.parse(response.body, symbolize_names: true))
    rescue StandardError => e
      Response.error(e.message)
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
