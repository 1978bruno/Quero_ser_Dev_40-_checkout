FactoryBot.define do
  factory :bonus_commission do
    description { "MyString" }
    start_date { "2023-02-14 21:37:11" }
    end_date { "2023-02-14 21:37:11" }
    comission_perc { "9.99" }
    amount_limit { "9.99" }
    active { false }
  end
end
