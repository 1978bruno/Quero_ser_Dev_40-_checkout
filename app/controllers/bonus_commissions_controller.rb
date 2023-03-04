class BonusCommissionsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @bonus_commissions = BonusCommission.where(active: true)
  end

  def new
    @bonus_commission = BonusCommission.new
  end

  def create
    @bonus_commission = BonusCommission.new(params.require(:bonus_commission).permit(:description, :start_date, :end_date, :commission_perc, 
                                                                                    :amount_limit))
    if @bonus_commission.save
      BonusCommission.update(@bonus_commission.id, active: true)
      redirect_to bonus_commissions_path, notice: 'Campanha de bonificação cadastrada com sucesso.'
    else
      flash.now[:alert] = 'Campanha não cadastrada.'
      render :_form
    end
  end

  def deactive
    BonusCommission.update(params[:id], active: false)
    redirect_to bonus_commissions_path
  end
end
