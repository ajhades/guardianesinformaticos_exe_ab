class Schedule < ApplicationRecord
    has_many :availabilities
    belongs_to :service
end
