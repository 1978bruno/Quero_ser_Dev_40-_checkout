module CreationOrdersControllerCustomer2
  extend ActiveSupport::Concern

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
end
