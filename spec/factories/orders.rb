FactoryBot.define do
  factory :order do
    customer { nil }
    product_plan_id { rand(100) }
    product_plan_frequency_id { rand(100) }
    price { rand(1..99.99).round(2) }
    discount { rand(1..99.99).round(2) }
    payment_mode { nil }
    status { 0 }
    cancel_reason { nil }
  end
end
