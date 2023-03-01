module CreationOrdersControllerCustomer
  extend ActiveSupport::Concern

  def search_customer
    api_result = CustomerService.get_customer(@creation_order.customer_identification)

    if api_result[:success]
      @customer = api_result[:data]
      @creation_order.customer_exists = true
      set_customer_data
    else
      @creation_order.customer_exists = false
      flash[:alert] = api_result[:data][:status_message]
    end

    set_session_customer_exists
  end

  def set_session_customer_exists
    session_merge({ customer_exists: @creation_order.customer_exists })
  end

  def set_customer_data
    return unless @creation_order.customer_exists

    set_creation_order_customer_data
    set_session_customer_data
  end

  def set_creation_order_customer_data
    @creation_order.customer_name = @customer[:name]
    @creation_order.customer_email = @customer[:email]
    @creation_order.customer_address = @customer[:address]
    @creation_order.customer_city = @customer[:city]

    set_creation_order_customer_data2
  end

  def set_creation_order_customer_data2
    @creation_order.customer_state = @customer[:state]
    @creation_order.customer_zipcode = @customer[:zipcode]
    @creation_order.customer_phone = @customer[:phone]
    @creation_order.customer_birthdate = @customer[:birthdate]
    @creation_order.customer_corporate_name = @customer[:corporate_name]
  end

  def clear_creation_order_customer_data
    @creation_order.customer_name = ''
    @creation_order.customer_email = ''
    @creation_order.customer_address = ''
    @creation_order.customer_city = ''

    clear_creation_order_customer_data2
  end

  def clear_creation_order_customer_data2
    @creation_order.customer_state = ''
    @creation_order.customer_zipcode = ''
    @creation_order.customer_phone = ''
    @creation_order.customer_birthdate = ''
    @creation_order.customer_corporate_name = ''
  end

  def set_session_customer_data
    customer_params = { customer_name: @customer[:name],
                        customer_email: @customer[:email],
                        customer_address: @customer[:address],
                        customer_city: @customer[:city],
                        customer_state: @customer[:state],
                        customer_zipcode: @customer[:zipcode],
                        customer_phone: @customer[:phone],
                        customer_birthdate: @customer[:birthdate],
                        customer_corporate_name: @customer[:corporate_name] }

    session_merge(customer_params)
  end
end
