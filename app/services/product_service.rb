class ProductService
  class << self
    def list_product_group
      response = Faraday.get "#{ENV.fetch('PRODUCTS_API_URL')}/product_groups"
      if response.status != 200
        return { success: false, data: { status_message: 'Não foi possível acessar a API de grupos de produto' } }
      end

      products = JSON.parse(response.body).map do |prod|
        { id: prod['id'], name: prod['name'], description: prod['description'] }
      end
      { success: true, data: products }
    rescue StandardError => e
      { success: false, data: { status_message: e.message } }
    end

    def list_plans(group_id)
      response = Faraday.get "#{ENV.fetch('PRODUCTS_API_URL', nil)}/product_groups/#{group_id}/plans"
      if response.status != 200
        return { success: false, data: { status_message: 'Não foi possível acessar a API de planos' } }
      end

      plans = JSON.parse(response.body).map do |prod|
        { id: prod['id'], name: prod['name'], description: prod['description'], details: prod['details'] }
      end
      { success: true, data: plans }
    rescue StandardError => e
      { success: false, data: { status_message: e.message } }
    end

    def list_prices(plan_id)
      response = Faraday.get "#{ENV.fetch('PRODUCTS_API_URL', nil)}/plans/#{plan_id}/prices"
      if response.status != 200
        return { success: false, data: { status_message: 'Não foi possível acessar a API de preços' } }
      end

      prices = parse_prices(response.body)
      { success: true, data: prices }
    rescue StandardError => e
      { success: false, data: { status_message: e.message } }
    end

    private

    def parse_prices(json_response)
      JSON.parse(json_response).map do |prod|
        { price: prod['price'], plan: prod['plan']['name'],
          periodicity: prod['periodicity']['name'] }
      end
    end
  end
end
