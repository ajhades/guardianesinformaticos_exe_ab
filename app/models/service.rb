class Service < ApplicationRecord
    has_many :users, schedules
    belongs_to :client
end
