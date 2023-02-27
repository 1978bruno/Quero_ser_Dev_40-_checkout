class CreationOrdersController < ApplicationController
  include CreationOrdersControllerShared

  before_action :authenticate_user!

  def new
    session[:creation_order_params] = {}
    session[:creation_order_step] = nil
    @creation_order = CreationOrder.new(session[:creation_order_params])
    @creation_order.current_step = session[:creation_order_step]
  end

  def create
    initialize_controller
    handle_form_step
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
                                           :product_group_form,
                                           :product_plan_form,
                                           :product_price_form)
  end
end
