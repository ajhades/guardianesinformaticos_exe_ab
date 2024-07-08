require 'rails_helper'

RSpec.describe Availability, type: :model do
  let(:user) { create(:user) }
  it "has a valid factory" do
    expect(build(:availability, user: user)).to be_valid
  end

  it "does not allow duplicates" do
    availability = create(:availability)  # Crea una instancia válida
    duplicate_availability = build(:availability, day_of_week: availability.day_of_week, time: availability.time, week: availability.week, date: availability.date)

    expect(duplicate_availability).not_to be_valid
    expect(duplicate_availability.errors[:base]).to include("there is already one")
  end

  it "is invalid without a day_of_week" do
    availability = build(:availability, day_of_week: nil)
    availability.valid?
    expect(availability.errors[:day_of_week]).to include("no puede estar en blanco")
  end
end