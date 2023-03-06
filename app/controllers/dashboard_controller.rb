class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    orders_status_data
    orders_products_data
  end

  private

  def orders_status_data
    orders_day = orders_status_day_data
    @orders_day_by_status = Order.statuses.map { |k, _v| [I18n.t(k), orders_day[k] || 0] }.to_h

    orders_month = orders_status_month_data
    @orders_month_by_status = Order.statuses.map { |k, _v| [I18n.t(k), orders_month[k] || 0] }.to_h
  end

  def orders_status_month_data
    if current_user.admin?
      Order.where("strftime('%Y-%m', created_at) = ?", Time.zone.today.strftime('%Y-%m'))
           .group(:status).count
    else
      current_user.orders.where("strftime('%Y-%m', created_at) = ?", Time.zone.today.strftime('%Y-%m'))
                  .group(:status).count
    end
  end

  def orders_status_day_data
    if current_user.admin?
      Order.where("strftime('%Y-%m-%d', created_at) = ?", Time.zone.today.strftime('%Y-%m-%d'))
           .group(:status).count
    else
      current_user.orders.where("strftime('%Y-%m-%d', created_at) = ?", Time.zone.today.strftime('%Y-%m-%d'))
                  .group(:status).count
    end
  end

  def orders_products_data
    @orders_month_by_product = orders_products_month_data
  end

  def orders_products_month_data
    if current_user.admin?
      Order.where("strftime('%Y-%m', created_at) = ?", Time.zone.today.strftime('%Y-%m'))
           .group(:product_group_name).count
    else
      current_user.orders.where("strftime('%Y-%m', created_at) = ?", Time.zone.today.strftime('%Y-%m'))
                  .group(:product_group_name).count
    end
  end
end
