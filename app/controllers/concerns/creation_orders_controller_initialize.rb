module CreationOrdersControllerInitialize
  extend ActiveSupport::Concern

  def initialize_controller
    session_merge(creation_order_params) if params[:creation_order]

    initialize_creation_order

    @disable_submit_button = false
    flash[:notice] = flash[:alert] = nil
  end

  def initialize_creation_order
    @creation_order = CreationOrder.new(session[:creation_order_params])
    @creation_order.current_step = session[:creation_order_step]
    @creation_order.no_error_found = session[:creation_order_no_error_found]
  end

  def session_merge(params)
    session[:creation_order_params].deep_merge!(params)
  end
end
