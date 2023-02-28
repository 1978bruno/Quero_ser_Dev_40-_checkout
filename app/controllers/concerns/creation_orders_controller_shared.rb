module CreationOrdersControllerShared
  extend ActiveSupport::Concern

  def initialize_controller
    session_merge(creation_order_params) if params[:creation_order]

    @creation_order = CreationOrder.new(session[:creation_order_params])
    @creation_order.current_step = session[:creation_order_step]
  end

  def handle_form_step
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
      flash[:notice] = I18n.t('creation_order.msg_order_created')
      redirect_to orders_path
    else
      render :new
    end
  end

  def handle_customer
    search_customer
  end

  def handle_customer_data; end

  def handle_product
    product_group_form = @creation_order.product_group_form.split('#')
    @creation_order.product_group_id = product_group_form[0]
    @creation_order.product_group_name = product_group_form[1]

    product_group_params = { product_group_id: @creation_order.product_group_id,
                             product_group_name: @creation_order.product_group_name }

    session_merge(product_group_params)
  end

  def handle_plans
    product_plan_form = @creation_order.product_plan_form.split('#')
    @creation_order.product_plan_id = product_plan_form[0]
    @creation_order.product_plan_name = product_plan_form[1]

    product_plan_params = { product_plan_id: @creation_order.product_plan_id,
                            product_plan_name: @creation_order.product_plan_name }

    session_merge(product_plan_params)
  end

  def handle_prices
    price_form = @creation_order.product_price_form.split('#')
    @creation_order.product_periodicity = price_form[0]
    @creation_order.product_price = price_form[1]

    product_price_params = { product_periodicity: @creation_order.product_periodicity,
                             product_price: @creation_order.product_price }

    session_merge(product_price_params)
  end

  def handle_confirmation
    ## TODO
    ## Neste ponto será gravado o novo pedido no BD
  end

  def search_customer
    ## TODO
    ## Buscar via API os dados de um cliente e verificar se ele está liberado

    @customer = { identification: '12345678901', name: 'José da Silva',
                  email: 'jose.silva@email.com.br', address: 'Rua das Palmeiras, 100',
                  city: 'São Paulo', state: 'SP', zipcode: '11111-111',
                  phone: '11-99999-8888', birth_date: '1980-01-01', corporate_name: '' }
    @creation_order.customer_exists = true

    return unless @creation_order.customer_exists

    @creation_order.customer_name = @customer[:name]
    @creation_order.customer_email = @customer[:email]
    @creation_order.customer_address = @customer[:address]
    @creation_order.customer_city = @customer[:city]
    @creation_order.customer_state = @customer[:state]
    @creation_order.customer_zipcode = @customer[:zipcode]
    @creation_order.customer_phone = @customer[:phone]
    @creation_order.customer_birth_date = @customer[:birth_date]
    @creation_order.customer_corporate_name = @customer[:corporate_name]

    customer_params = { customer_name: @customer[:name],
                        customer_email: @customer[:email],
                        customer_address: @customer[:address],
                        customer_city: @customer[:city],
                        customer_state: @customer[:state],
                        customer_zipcode: @customer[:zipcode],
                        customer_phone: @customer[:phone],
                        customer_birth_date: @customer[:birth_date],
                        customer_corporate_name: @customer[:corporate_name] }

    session_merge(customer_params)
  end

  def before_product
    ## TODO
    ## Buscar via API os grupos de produtos
    @products = [{ id: 1, name: 'Hospedagem de Sites',
                   description: 'Domínio e SSL grátis com sites ilimitados e o melhor custo-benefício' },
                 { id: 2, name: 'E-mail Locaweb',
                   description: 'Tenha um e-mail profissional e passe mais credibilidade' },
                 { id: 3, name: 'Criador de Sites',
                   description: 'Crie um site incrível com e-mails e domínio grátis!' }]
  end

  def before_plans
    ## TODO
    ## Buscar via API os planos disponíveis para um grupo de produtos
    @product_plans = [{ id: 1, name: 'Hospedagem GO',
                        description: '1 Site, 3 Contas de e-mails(10GB cada), 1 ano de domínio grátis',
                        details: '1 usuário FTP, Armazenamento e Transferencia ilimitada' },
                      { id: 2, name: 'Hospedagem I',
                        description: 'Sites ilimitados, 25 Contas de e-mails(10GB cada), 1 ano de domínio grátis',
                        details: '1 usuário FTP, Armazenamento e Transferencia ilimitada' }]
  end

  def before_prices
    ## TODO
    ## Buscar via API os preços e periodicidades de um plano
    @product_plan_prices = [{ periodicity: 'Trimestral', price: 59.97 },
                            { periodicity: 'Anual', price: 191.88 }]
  end

  def session_merge(params)
    session[:creation_order_params].deep_merge!(params)
  end
end
