FactoryBot.define do
    factory :availability do
        day = Faker::Date.backward(days: 7)
        day_of_week { day.cwday }
        week { day.cweek }
        date { day }
        time { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :exact_hours) }
        association :user, factory: :user
    end
end