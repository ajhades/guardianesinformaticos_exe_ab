class Service < ApplicationRecord
    has_many :user_services
    has_many :users, through: :user_services
    has_many :schedules
    belongs_to :client

    
end
