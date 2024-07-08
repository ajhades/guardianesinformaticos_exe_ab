FactoryBot.define do
    factory :daily_shift do
        day = Faker::Date.backward(days: 7)
        week { day.cweek }
        date { day }
        start_time { Faker::Time.between(from: DateTime.now.beginning_of_day, to: DateTime.now.at_midday, format: :exact_hours) }
        end_time { Faker::Time.between(from: DateTime.now.at_midday + 1.hour, to: DateTime.now.end_of_day, format: :exact_hours) }
        last_modification { Faker::Date.backward(days: 14) }
        association :user, factory: :user
        association :schedule, factory: :schedule
    end
end