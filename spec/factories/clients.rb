FactoryBot.define do
    factory :client do
      name { Faker::Name.name }
      nit { Faker::Number.number(digits: 10) }
      status { "1" }
    end
end