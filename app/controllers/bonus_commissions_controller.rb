class BonusCommissionsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]

  def index
    @bonus_commissions = BonusCommission.where(active: true)
  end

  def new
    @bonus_commission = BonusCommission.new
  end

  def edit
    @bonus_commission = BonusCommission.find(params[:id])
  end

  def create
    @bonus_commission = BonusCommission.new(params.require(:bonus_commission).permit(:description, :start_date,
                                                                                     :end_date, :commission_perc,
                                                                                     :amount_limit))
    if @bonus_commission.save
      BonusCommission.update(@bonus_commission.id, active: true)
      redirect_to bonus_commissions_path, notice: I18n.t('bonus_commission.msg_create_success')
    else
      flash.now[:alert] = I18n.t('bonus_commission.msg_create_unsuccess')
      render :new
    end
  end

  def update
    @bonus_commission = BonusCommission.update(params[:id], params.require(:bonus_commission).permit(:description,
                                                                                                     :start_date,
                                                                                                     :end_date,
                                                                                                     :commission_perc,
                                                                                                     :amount_limit))
    if @bonus_commission.valid?
      redirect_to bonus_commissions_path
    else
      render :edit
    end
  end

  def deactive
    BonusCommission.update(params[:id], active: false)
    redirect_to bonus_commissions_path
  end
end
