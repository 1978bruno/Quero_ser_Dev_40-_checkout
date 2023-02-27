class ProductService
  class << self
    def list_product_group
      response = Faraday.get "#{ENV.fetch('PRODUCTS_API_URL')}/product_groups"
      if response.status != 200
        return { success: false, data: { status_message: 'Não foi possível acessar a API de grupos de produto' } }
      end

      products = JSON.parse(response.body)
      products.map do |prod|
        { success: true, data: { id: prod[:id], name: prod[:name], description: prod[:description] } }
      end
    rescue StandardError => e
      { success: false, data: { status_message: e } }
    end

    def list_plans(group_id)
      response = Faraday.get "#{ENV.fetch('PRODUCTS_API_URL', nil)}/product_groups/#{group_id}/plans"
      if response.status != 200
        return { success: false, data: { status_message: 'Não foi possível acessar a API de planos' } }
      end

      products = JSON.parse(response.body)
      products.map do |prod|
        { success: true, data: { id: prod[:id], name: prod[:name], description: prod[:description] } }
      end
    rescue StandardError => e
      { success: false, data: { status_message: e } }
    end

    def list_prices(plan_id)
      response = Faraday.get "#{ENV.fetch('PRODUCTS_API_URL', nil)}/plans/#{plan_id}/prices"
      if response.status != 200
        return { success: false, data: { status_message: 'Não foi possível acessar a API de planos' } }
      end

      JSON.parse(response.body).map do |prod|
        { success: true, data: { price: prod[:price], plan: prod[:plan], periodicity: prod[:periodicity],
                                 product_group: prod[:product_group] } }
      end
    rescue StandardError => e
      { success: false, data: { status_message: e } }
    end
  end
end
