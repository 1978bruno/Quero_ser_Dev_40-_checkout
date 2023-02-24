class ProductService
  class << self
    def list_products
      response_api = Faraday.get ENV['PRODUCT_API_URL'] || 'http://localhost:3001'
      return { erro: 'Não foi possível acessar a API de produtos' } if response_api.status != 200

      map_values(response_api.body)
    rescue StandardError => e
      { erro: e.message }
    end

    private

    def check_response(product_object)
      product_object.include?(:plan_name) && product_object.include?(:periodicity) &&
        product_object.include?(:price)
    end

    def map_values(response_body)
      response_body.map do |product|
        raise StandardError, 'Conteúdo inválido na API' unless check_response(product)

        { product_plan_name: product[:plan_name],
          product_plan_periodicity: product[:periodicity],
          price: product[:price] }
      end
    end
  end
end
