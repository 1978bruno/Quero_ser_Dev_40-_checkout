module CreationOrdersControllerBeforeActions
  extend ActiveSupport::Concern

  def before_actions_next_step
    @creation_order.no_error_found = true unless @creation_order.current_step == 'confirmation'

    case @creation_order.current_step
    when 'products'
      before_products
    when 'plans'
      before_plans
    when 'prices'
      before_prices
    end

    set_session_no_error_found
  end

  def before_products
    api_result = ProductService.list_product_group

    if api_result[:status] == 'SUCCESS'
      @products = api_result[:data]
    else
      @creation_order.no_error_found = false
      @disable_submit_button = true
      @products = []
      flash[:alert] = api_result[:status_message]
    end
  end

  def before_plans
    api_result = ProductService.list_plans(@creation_order.product_group_id)

    if api_result[:status] == 'SUCCESS'
      @product_plans = api_result[:data]
    else
      @creation_order.no_error_found = false
      @disable_submit_button = true
      @product_plans = []
      flash[:alert] = api_result[:status_message]
    end
  end

  def before_prices
    api_result = ProductService.list_prices(@creation_order.product_plan_id)

    if api_result[:status] == 'SUCCESS'
      @product_plan_prices = api_result[:data]
    else
      @creation_order.no_error_found = false
      @disable_submit_button = true
      @product_plan_prices = []
      flash[:alert] = api_result[:status_message]
    end
  end

  def set_session_no_error_found
    session[:creation_order_no_error_found] = @creation_order.no_error_found
  end
end
