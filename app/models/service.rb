class Service < ApplicationRecord
    has_many :users
    has_many :schedules
    belongs_to :client
end
