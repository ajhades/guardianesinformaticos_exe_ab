FactoryBot.define do
    factory :user do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        document { Faker::Number.number(digits: 10) }
        role { 'Developer' }
        email { Faker::Internet.email }
        password { 'topscret' }
        password_confirmation { 'topscret' }
        association :client, factory: :client
    end
end