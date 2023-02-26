class CreationOrder
  include ActiveModel::Model

  attr_accessor :customer_identification,
                :customer_name,
                :customer_address,
                :customer_city,
                :customer_state,
                :customer_zipcode,
                :customer_email,
                :customer_phone,
                :customer_birth_date,
                :customer_corporate_name,
                :product_group,
                :product_plan,
                :product_price_component,
                :product_periodicity,
                :product_price
  attr_writer :current_step

  validates :customer_identification, presence: { if: ->(o) { o.current_step == 'customer' } }

  validates :customer_identification, presence: { if: ->(o) { o.current_step == 'customer_data' } }
  validates :customer_name, presence: { if: ->(o) { o.current_step == 'customer_data' } }
  validates :customer_address, presence: { if: ->(o) { o.current_step == 'customer_data' } }
  validates :customer_city, presence: { if: ->(o) { o.current_step == 'customer_data' } }
  validates :customer_state, presence: { if: ->(o) { o.current_step == 'customer_data' } }
  validates :customer_zipcode, presence: { if: ->(o) { o.current_step == 'customer_data' } }
  validates :customer_email, presence: { if: ->(o) { o.current_step == 'customer_data' } }
  validates :customer_phone, presence: { if: ->(o) { o.current_step == 'customer_data' } }
  validates :customer_birth_date, presence: { if: ->(o) { o.current_step == 'customer_data' } }

  #  validates :customer_corporate_name, presence: { if: ->(o) { o.current_step == 'customer_data' } }

  validates :product_group, presence: { if: ->(o) { o.current_step == 'product' } }

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[customer customer_data product plans prices confirmation]
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
end
