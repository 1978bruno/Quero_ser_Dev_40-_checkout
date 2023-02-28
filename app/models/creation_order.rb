require 'cpf_cnpj'

class CreationOrder
  include ActiveModel::Model

  attr_accessor :customer_exists, :customer_identification, :customer_name, :customer_address, :customer_city,
                :customer_state, :customer_zipcode, :customer_email, :customer_phone, :customer_birthdate,
                :customer_corporate_name, :product_group_form, :product_group_id, :product_group_name,
                :product_plan_form, :product_plan_id, :product_plan_name, :product_price_form,
                :product_plan_periodicity, :product_plan_price, :no_error_found

  attr_writer :current_step

  validates :customer_identification, presence:
            { if: ->(o) { o.current_step == 'customer' } }
  validate  :validate_customer_identification
  validate  :customer_blacklisted?

  validates :customer_identification, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_name, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_address, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_city, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_state, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_zipcode, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_email, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_phone, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }
  validates :customer_birthdate, presence:
            { if: ->(o) { o.current_step == 'customer_data' && o.customer_exists == false } }

  #  validates :customer_corporate_name, presence: { if: ->(o) { o.current_step == 'customer_data' } }

  validates :product_group_form, presence:
            { if: ->(o) { o.current_step == 'product' && o.no_error_found } }
  validates :product_plan_form, presence:
            { if: ->(o) { o.current_step == 'plans' && o.no_error_found } }
  validates :product_price_form, presence:
            { if: ->(o) { o.current_step == 'prices' && o.no_error_found } }

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[customer customer_data products plans prices confirmation]
  end

  def next_step
    self.current_step = steps[steps.index(current_step) + 1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step) - 1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  def validate_customer_identification
    return unless current_step == 'customer' || current_step == 'customer_data'

    case customer_identification.size
    when 11
      validate_customer_cpf
    when 14
      validate_customer_cnpj
    else
      errors.add(:base, I18n.t('creation_order.msg_invalid_value'))
    end
  end

  def validate_customer_cpf
    errors.add(:base, I18n.t('creation_order.msg_invalid_cpf')) unless CPF.valid?(customer_identification)
  end

  def validate_customer_cnpj
    errors.add(:base, I18n.t('creation_order.msg_invalid_cnpj')) unless CNPJ.valid?(customer_identification)
  end

  def customer_blacklisted?
    return unless current_step == 'customer'

    blacklisted_customer = BlacklistedCustomer.find_by(doc_ident: customer_identification)

    return unless blacklisted_customer

    errors.add(:base, I18n.t('creation_order.msg_customer_blacklisted'))
  end
end
