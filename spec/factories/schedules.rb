FactoryBot.define do
    factory :schedule do
        day_of_week { Faker::Date.backward(days: 7).cwday }
        start_time { Faker::Time.between(from: DateTime.now.beginning_of_day, to: DateTime.now.at_midday, format: :exact_hours) }
        end_time { Faker::Time.between(from: DateTime.now.at_midday + 1.hour, to: DateTime.now.end_of_day, format: :exact_hours) }
        association :service, factory: :service
    end
end