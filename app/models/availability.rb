class Availability < ApplicationRecord
    belongs_to :user, :schedule
end
