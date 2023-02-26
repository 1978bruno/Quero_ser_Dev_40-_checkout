module CreationOrdersControllerShared
  extend ActiveSupport::Concern

  def initialize_controller
    session[:creation_order_params].deep_merge!(creation_order_params) if params[:creation_order]

    @creation_order = CreationOrder.new(session[:creation_order_params])
    @creation_order.current_step = session[:creation_order_step]
  end

  def handle_each_step
    return unless @creation_order.valid?

    case @creation_order.current_step
    when 'customer'
      handle_customer
    when 'customer_data'
      handle_customer_data
    when 'product'
      handle_product
    when 'plans'
      handle_plans
    when 'prices'
      handle_prices
    when 'confirmation'
      handle_confirmation
    end
  end  

  def control_flow
    return unless @creation_order.valid?

    @end_process = false

    if params[:back_button]
      @creation_order.previous_step
    elsif @creation_order.last_step?
      @end_process = true
    else
      @creation_order.next_step
    end

    session[:creation_order_step] = @creation_order.current_step
  end

  def before_each_step
    case @creation_order.current_step
    when 'product'
      before_product
    when 'plans'
      before_plans
    when 'prices'
      before_prices
    end
  end 

  def decides_next_view
    if @end_process
      session[:creation_order_step] = session[:creation_order_params] = nil
      flash[:notice] = 'Order saved!'
      redirect_to orders_path
    else
      render :new
    end
  end

  def handle_customer
    search_customer

    @show_customer = @customer_exists
  end

  def handle_customer_data
  end

  def handle_product
  end

  def handle_plans
  end

  def handle_prices
    price_component = @creation_order.product_price_component.split(' ')
    @creation_order.product_periodicity = price_component[0]
    @creation_order.product_price = price_component[1]
  end

  def handle_confirmation
  end

  def search_customer
    @customer = { 'identification': '12345678901', 'name': 'José da Silva',
                  'email': 'jose.silva@email.com.br', 'address': 'Rua das Palmeiras, 100',
                  'city': 'São Paulo', 'state': 'SP', 'zipcode': '11111-111',
                  'phone': '11-99999-8888', 'birth_date': '1980-01-01', 'corporate_name': ''}
    @customer_exists = true

    logger.info "@customer = #{@customer}"
    logger.info "@customer['name'] = #{@customer[:name]}"

    @creation_order.customer_name = @customer[:name]
    @creation_order.customer_email = @customer[:email]
    @creation_order.customer_address = @customer[:address]
    @creation_order.customer_city = @customer[:city]
    @creation_order.customer_state = @customer[:state]
    @creation_order.customer_zipcode = @customer[:zipcode]
    @creation_order.customer_phone = @customer[:phone]
    @creation_order.customer_birth_date = @customer[:birth_date]
    @creation_order.customer_corporate_name = @customer[:corporate_name]

    logger.info "@creation_order: #{@creation_order.instance_values}"
  end

  def before_product
    @products = [ { 'name': 'Hospedagem de Sites', 'description': 'Domínio e SSL grátis com sites ilimitados e o melhor custo-benefício' },
                  { 'name': 'E-mail Locaweb', 'description': 'Tenha um e-mail profissional e passe mais credibilidade' },
                  { 'name': 'Criador de Sites', 'description': 'Crie um site incrível com e-mails e domínio grátis!' } ] 

    @products.each do |product|
      logger.info "product = #{product[:name]} - #{product[:description]}"
    end
  end

  def before_plans
    @product_plans = [ { 'name': 'Hospedagem GO', 'description': '1 Site, 3 Contas de e-mails(10GB cada), 1 ano de domínio grátis',
                         'details': '1 usuário FTP, Armazenamento e Transferencia ilimitada' },
                       { 'name': 'Hospedagem I', 'description': 'Sites ilimitados, 25 Contas de e-mails(10GB cada), 1 ano de domínio grátis',
                         'details': '1 usuário FTP, Armazenamento e Transferencia ilimitada' }
                     ] 

    @product_plans.each do |product_plan|
      logger.info "product_plan = #{product_plan[:name]} - #{product_plan[:description]} - #{product_plan[:details]}"
    end
  end

  def before_prices
    @product_plan_prices = [ { 'periodicity': 'Trimestral', 'price': 59.97 },
                             { 'periodicity': 'Anual', 'price': 191.88 }
                           ] 

    @product_plan_prices.each do |product_plan|
      logger.info "product_plan = #{product_plan[:periodicity]} - #{product_plan[:price]}"
    end
  end
end
