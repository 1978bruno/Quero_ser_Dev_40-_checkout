class PaidCommissionsController < ApplicationController
  before_action :authenticate_user!, :redirect_unless_admin, only: %i[index salesman]

  def index
    query_salesman = params[:search_salesman]
    @period = period_text
    @paid_commissions = PaidCommission.all.group(:salesman_id).sum(:amount).transform_keys do |id|
      User.find(id)
    end
    return if query_salesman.blank?

    salesmen_commissions = salesmen_paid_commissions(query_salesman)
    no_results_found(salesmen_commissions)
    @paid_commissions = salesmen_commissions
  end

  def salesman
    @user = User.find(params[:user_id])
    @period = params[:period]
    @paid_commissions = @user.paid_commissions
  end

  private

  def period_text
    start_d = params[:start_date]
    end_d = params[:end_date]
    start_d = start_d.nil? || start_d == '' ? 'primeiro dado disponível' : start_d.to_date.strftime('%d/%m/%Y')
    end_d = end_d.nil? || end_d == '' ? 'último dado disponível' : end_d.to_date.strftime('%d/%m/%Y')
    "De: #{start_d} até: #{end_d}"
  end

  def redirect_unless_admin
    return if current_user.try(:admin?)
  end

  def salesmen_paid_commissions(query_salesman)
    salesmen = User.where('name like ?', "%#{query_salesman}%")
    PaidCommission.where(salesman_id: salesmen).group(:salesman_id).sum(:amount).transform_keys do |id|
      User.find(id)
    end
  end

  def no_results_found(salesman_commissions)
    return if salesman_commissions.present?

    flash.now[:alert] = 'Não foram encontradas comissões pagas para esse critério'
    render :index
  end
end
