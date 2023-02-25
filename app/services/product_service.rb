class ProductService
  class << self
    def list_products
      response = Faraday.get(ENV.fetch('PRODUCTS_API_URL', nil))
      return { erro: 'Não foi possível acessar a API de produtos' } if response.status != 200

      products = JSON.parse(response.body)['products']
      map_values(products)
    rescue StandardError => e
      { erro: e.message }
    end

    private

    def map_values(products)
      products.map do |product|
        raise StandardError, 'Conteúdo inválido na API' unless check_response(product)

        { product_plan_name: product['plan_name'],
          product_plan_periodicity: product['periodicity'],
          price: product['price'] }
      end
    end

    def check_response(product)
      product.include?('plan_name') && product.include?('periodicity') &&
        product.include?('price')
    end
  end
end
