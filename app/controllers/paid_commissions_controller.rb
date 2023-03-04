class PaidCommissionsController < ApplicationController
  before_action :authenticate_user!, :redirect_unless_admin, only: %i[index]
  def index
    query_salesman = params[:search_salesman]
    @paid_commissions = PaidCommission.all.group(:salesman_id).sum(:amount).transform_keys do |id|
      User.find(id)
    end

    return if query_salesman.blank?

    salesmen = User.where('name like ?', "%#{query_salesman}%")

    salesman_commissions = salesman_paid_commissions(salesmen)

    if salesman_commissions.blank?
      flash.now[:alert] = 'Não foram encontradas comissões pagas para esse critério'
      render :index
    end
    @paid_commissions = salesman_commissions
  end

  private

  def redirect_unless_admin
    return if current_user.try(:admin?)
  end

  def salesman_paid_commissions(salesmen)
    PaidCommission.where(salesman_id: salesmen).group(:salesman_id).sum(:amount).transform_keys do |id|
      User.find(id)
    end
  end
end
