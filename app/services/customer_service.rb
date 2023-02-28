class CustomerService
  class << self
    def get_customer(customer_doc_ident)
      response = Faraday.get("#{ENV.fetch('CUSTOMER_API_URL')}/#{customer_doc_ident}")
      return { success: false, data: {} } if response.status == 404
      if response.status != 200 || !check_response(response)
        return { success: false, data: { status_message: 'Não foi possível acessar a API de clientes' } }
      end

      customer = JSON.parse(response.body)
      convert_customer(customer)
    rescue StandardError => e
      { success: false, data: { status_message: e.message } }
    end

    private

    def check_response(response)
      response.body.include?('name') && response.body.include?('doc_ident') && response.body.include?('email')
    end

    def convert_customer(customer)
      { success: true, data: { doc_ident: customer['doc_ident'], name: customer['name'],
                               email: customer['email'], address: customer['address'],
                               city: customer['city'], state: customer['state'],
                               zipcode: customer['zipcode'], phone: customer['phone'],
                               birthdate: customer['birthdate'], corporate_name: customer['corporate_name'] } }
    end
  end
end
