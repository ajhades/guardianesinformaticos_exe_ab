FactoryBot.define do
    factory :service do
      name { Faker::Commerce.product_name }
      start_date { Faker::Date.between(from: 2.years.ago, to: Date.today) }
      end_date { Faker::Date.forward(days: 5.years) }
      status { "1" }
      association :client, factory: :client
    end
end