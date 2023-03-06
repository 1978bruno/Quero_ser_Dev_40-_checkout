class PaidCommissionsController < ApplicationController
  before_action :authenticate_user!, :redirect_unless_admin, only: %i[index salesman]

  def index
    query_salesman = params[:search_salesman]
    @start_date = date_or_empty(params[:start_date])
    @end_date = date_or_empty(params[:end_date])
    @paid_commissions = load_all_commissions
    return if query_salesman.blank?

    salesmen_commissions = salesmen_paid_commissions(query_salesman)
    no_results_found(salesmen_commissions)
    @paid_commissions = salesmen_commissions
  end

  def salesman
    @user = User.find(params[:user_id])
    @start_date = date_or_empty(params[:start_date])
    @end_date = date_or_empty(params[:end_date])
    @paid_commissions = @user.paid_commissions
                             .after_start_date(@start_date)
                             .before_end_date(@end_date)
  end

  private

  def redirect_unless_admin
    return if current_user.try(:admin?)
  end

  def date_or_empty(date)
    date.nil? || date == '' ? '' : date.to_date
  end

  def load_all_commissions
    PaidCommission.after_start_date(@start_date)
                  .before_end_date(@end_date)
                  .group(:salesman_id)
                  .sum(:amount)
                  .transform_keys do |id|
                    User.find(id)
                  end
  end

  def salesmen_paid_commissions(query_salesman)
    salesmen = User.where('name like ?', "%#{query_salesman}%")
    PaidCommission.where(salesman: salesmen)
                  .after_start_date(@start_date)
                  .before_end_date(@end_date)
                  .group(:salesman_id)
                  .sum(:amount)
                  .transform_keys do |id|
                    User.find(id)
                  end
  end

  def no_results_found(salesman_commissions)
    return if salesman_commissions.present?

    flash.now[:alert] = 'Não foram encontradas comissões pagas para esse critério'
    @paid_commissions = nil
    render :index
  end
end
