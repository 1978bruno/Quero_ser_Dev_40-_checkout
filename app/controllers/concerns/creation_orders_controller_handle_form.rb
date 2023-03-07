module CreationOrdersControllerHandleForm
  extend ActiveSupport::Concern

  def handle_form_current_step
    return unless @creation_order.valid?
    return unless @creation_order.no_error_found

    case @creation_order.current_step
    when 'customer'
      handle_form_customer
    when 'customer_data'
      handle_form_customer_data
    else
      handle_form_current_step2
    end
  end

  def handle_form_current_step2
    case @creation_order.current_step
    when 'products'
      handle_form_products
    when 'plans'
      handle_form_plans
    when 'prices'
      handle_form_prices
    when 'confirmation'
      handle_form_confirmation
    end
  end

  def handle_form_customer
    clear_creation_order_customer_data
    search_customer
  end

  def handle_form_customer_data
    return if @creation_order.customer_exists
    return if @creation_order.customer_data_sent

    send_customer_data_via_api
  end

  def handle_form_products
    product_group_form = @creation_order.product_group_form.split('#')
    @creation_order.product_group_id = product_group_form[0]
    @creation_order.product_group_name = product_group_form[1]

    product_group_params = { product_group_id: @creation_order.product_group_id,
                             product_group_name: @creation_order.product_group_name }

    session_merge(product_group_params)
  end

  def handle_form_plans
    product_plan_form = @creation_order.product_plan_form.split('#')
    @creation_order.product_plan_id = product_plan_form[0]
    @creation_order.product_plan_name = product_plan_form[1]

    product_plan_params = { product_plan_id: @creation_order.product_plan_id,
                            product_plan_name: @creation_order.product_plan_name }

    session_merge(product_plan_params)
  end

  def handle_form_prices
    price_form = @creation_order.product_price_form.split('#')
    @creation_order.product_plan_periodicity_id = price_form[0]
    @creation_order.product_plan_periodicity = price_form[1]
    @creation_order.product_plan_price = price_form[2]

    product_price_params = { product_plan_periodicity_id: @creation_order.product_plan_periodicity_id,
                             product_plan_periodicity: @creation_order.product_plan_periodicity,
                             product_plan_price: @creation_order.product_plan_price }

    session_merge(product_price_params)
  end

  def handle_form_confirmation
    @order = new_order_object

    if @order.valid? && @order.save
      flash[:notice] = I18n.t('creation_order.msg_order_created')
    else
      assemble_order_error_message
      @creation_order.no_error_found = false
    end
  end

  def new_order_object
    Order.new(customer_doc_ident: @creation_order.customer_identification,
              product_group_id: @creation_order.product_group_id,
              product_group_name: @creation_order.product_group_name,
              product_plan_id: @creation_order.product_plan_id,
              product_plan_name: @creation_order.product_plan_name,
              product_plan_periodicity_id: @creation_order.product_plan_periodicity_id,
              product_plan_periodicity: @creation_order.product_plan_periodicity,
              price: @creation_order.product_plan_price,
              salesman_id: current_user.id)
  end

  def send_customer_data_via_api
    customer_data = create_customer_data_payload

    @api_result = CustomerService.save_customer(customer_data)

    return unless @api_result[:status] == 'SUCCESS'

    assemble_customer_error_message
    @creation_order.no_error_found = false
  end

  def assemble_order_error_message
    flash[:alert] = [I18n.t('creation_order.msg_order_not_created')]
    @order.errors.full_messages.each do |msg|
      flash[:alert] << msg
    end
  end

  def assemble_customer_error_message
    flash[:alert] = [I18n.t('creation_order.msg_customer_api_error')]
    flash[:alert] << @api_result[:status_message] if @api_result[:status] == 'ERROR_API'
  end
end
