class CreationOrdersController < ApplicationController
  include CreationOrdersControllerShared

  before_action :authenticate_user!

  def new
    session[:creation_order_params] ||= {}
    @creation_order = CreationOrder.new(session[:creation_order_params])
    @creation_order.current_step = session[:creation_order_step]
  end

  def create
    initialize_controller
   
    logger.info "Current Step: #{@creation_order.current_step}"
    logger.info "Valid?: #{@creation_order.valid?}"
    logger.info "Errors: #{@creation_order.errors.full_messages}"

    handle_each_step
    control_flow
    before_each_step
    decides_next_view
  end

  private

  def creation_order_params
    params.require(:creation_order).permit(:customer_identification,
                                           :customer_name,
                                           :customer_address,
                                           :customer_city,
                                           :customer_state,
                                           :customer_zipcode,
                                           :customer_email,
                                           :customer_phone,
                                           :customer_birth_date,
                                           :customer_corporate_name,
                                           :product_group,
                                           :product_plan,
                                           :product_price_component)
  end
end
