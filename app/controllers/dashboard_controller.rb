class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @salesmen_list = User.where(active: true)

    check_filter_in_use

    orders_status_data
    orders_products_data
    orders_periodicity_data
  end

  private

  def check_filter_in_use
    @all_salesman = @filter_activated = false
    @salesman = current_user

    return unless current_user.admin?

    check_filter_in_use_admin
  end

  def check_filter_in_use_admin
    if params[:salesman_id].present? && params[:salesman_id] != ''
      @salesman = @salesmen_list.select { |salesman| salesman.id == params[:salesman_id].to_i }.first
      @filter_activated = true
    else
      @all_salesmen = true
    end
  end

  def orders_status_data
    orders_day = orders_status_day_data
    @orders_day_by_status = Order.statuses.to_h { |k, _v| [I18n.t(k), orders_day[k] || 0] }

    orders_month = orders_status_month_data
    @orders_month_by_status = Order.statuses.to_h { |k, _v| [I18n.t(k), orders_month[k] || 0] }
  end

  def orders_status_day_data
    if @all_salesmen
      Order.where("strftime('%Y-%m-%d', created_at) = ?", Time.zone.today.strftime('%Y-%m-%d'))
           .group(:status).count
    else
      @salesman.orders.where("strftime('%Y-%m-%d', created_at) = ?", Time.zone.today.strftime('%Y-%m-%d'))
               .group(:status).count
    end
  end

  def orders_status_month_data
    if @all_salesmen
      Order.where("strftime('%Y-%m', created_at) = ?", Time.zone.today.strftime('%Y-%m'))
           .group(:status).count
    else
      @salesman.orders.where("strftime('%Y-%m', created_at) = ?", Time.zone.today.strftime('%Y-%m'))
               .group(:status).count
    end
  end

  def orders_products_data
    @orders_month_by_product = orders_products_month_data
  end

  def orders_products_month_data
    if @all_salesmen
      Order.where("strftime('%Y-%m', created_at) = ?", Time.zone.today.strftime('%Y-%m'))
           .group(:product_group_name).count
    else
      @salesman.orders.where("strftime('%Y-%m', created_at) = ?", Time.zone.today.strftime('%Y-%m'))
               .group(:product_group_name).count
    end
  end

  def orders_periodicity_data
    @orders_month_by_periodicity = orders_periodicity_month_data
  end

  def orders_periodicity_month_data
    if @all_salesmen
      Order.where("strftime('%Y-%m', created_at) = ?", Time.zone.today.strftime('%Y-%m'))
           .group(:product_plan_periodicity).count
    else
      @salesman.orders.where("strftime('%Y-%m', created_at) = ?", Time.zone.today.strftime('%Y-%m'))
               .group(:product_plan_periodicity).count
    end
  end
end
