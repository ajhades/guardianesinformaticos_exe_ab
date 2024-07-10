# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'
days = ["L", "M", "X", "J", "V"]
def generate_random_time
    hour = rand(0..18)
    Time.new(2000, 1, 1, hour).strftime('%H:%M')
end
client1 = Client.create(name: Faker::JapaneseMedia::CowboyBebop.character , nit: Faker::Number.number(digits: 10), status: 1)
3.times do |i|
    service = client1.services.create(name: Faker::JapaneseMedia::CowboyBebop.episode, start_date: rand(10.years).seconds.ago, end_date: rand(10.years).seconds.from_now, status:1)
    
    5.times do |n|
        service.schedules.create(day_of_week: days.sample, start_time: generate_random_time, end_time: generate_random_time)
    end
    4.times do |i|
        user = User.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, document: Faker::Number.number(digits: 10), role: 'Developer', status:'1', email: Faker::Internet.email, password: 'topsecret', password_confirmation: 'topsecret', client: client1)
        user.save!
        100.times do |i|
            date = Faker::Date.between(from: 6.days.ago, to: Date.today)
            # user.availabilities.create(day_of_week: days.sample, time: generate_random_time, week: 1, date: rand(7.days).seconds.ago )
            user.availabilities.create(day_of_week: date.cwday, time: generate_random_time, week: date.cweek, date: date )
        end
        UserService.create!(user: user, service: service)
    end
end





Client.create(name: Faker::JapaneseMedia::CowboyBebop.character, nit:  Faker::Number.number(digits: 10), status: 1)