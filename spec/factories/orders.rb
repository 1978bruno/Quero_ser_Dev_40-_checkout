FactoryBot.define do
  factory :order do
    customer { nil }
    product_plan_id { 1 }
    product_plan_frequency_id { 1 }
    price { '9.99' }
    discount { '9.99' }
    payment_mode { 'MyString' }
    status { 1 }
    cancel_reason { 'MyString' }
  end
end
