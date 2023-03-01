class BlacklistedCustomersController < ApplicationController
  before_action :authenticate_user!, :redirect_unless_admin, only: %i[index save destroy]

  def index
    query_doc_ident = params[:customer_doc_ident]
    @blacklisted_customers = BlacklistedCustomer.all

    return if query_doc_ident.blank?

    customer_blacklisted = customer_check_blacklist(query_doc_ident)
    if customer_blacklisted.present?
      @blacklisted_customers = [customer_blacklisted]
      @already_blacklisted = true
    end
    @customer = process_customer_from_api(query_doc_ident, @already_blacklisted)
  end

  def save
    BlacklistedCustomer.create!({ doc_ident: params[:id], blacklisted_reason: params[:blacklisted_reason] })
    redirect_to blacklisted_customers_path, notice: I18n.t('blacklisted_customer.msg_customer_blocked')
  rescue ActiveRecord::RecordInvalid
    redirect_to blacklisted_customers_path, alert: I18n.t('blacklisted_customer.msg_customer_block_fail')
  end

  def destroy
    customer_id = params[:id]
    customer = BlacklistedCustomer.find(customer_id)
    customer.destroy!
    redirect_to blacklisted_customers_path, notice: I18n.t('blacklisted_customer.msg_customer_unblocked')
  rescue ActiveRecord::RecordNotDestroyed
    redirect_to blacklisted_customers_path, alert: I18n.t('blacklisted_customer.msg_customer_unblock_fail')
  end

  private

  def redirect_unless_admin
    return if current_user.try(:admin?)

    redirect_to root_path
  end

  def customer_check_blacklist(doc_ident)
    BlacklistedCustomer.find_by(doc_ident:)
  end

  def process_customer_from_api(query_doc_ident, is_blacklisted)
    customer_data_from_api = CustomerService.get_customer(query_doc_ident)

    if customer_data_from_api[:status] != 'SUCCESS' && !is_blacklisted
      flash.now[:alert] = customer_data_from_api[:status_message] and return
    end

    customer_data_from_api[:data]
  end
end
