class BlacklistedCustomersController < ApplicationController
  before_action :authenticate_user!, :redirect_unless_admin, only: %i[index save destroy]

  def index
    @blacklisted_customers = BlacklistedCustomer.all
  end

  def save; end

  def destroy
    customer_id = params[:id]
    customer = BlacklistedCustomer.find(customer_id)
    customer.destroy!
    redirect_to blacklisted_customers_path, notice: 'Cliente desbloqueado' and return
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to price_weights_path, alert: 'Não foi possível desbloquear o cliente'
  end

  private

  def redirect_unless_admin
    return if current_user.try(:admin?)

    redirect_to root_path
  end
end
