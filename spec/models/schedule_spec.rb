require 'rails_helper'

RSpec.describe Schedule, type: :model do
  it "has a valid factory" do
    expect(create(:schedule)).to be_valid
  end

  it "is invalid without a day_of_week" do
    schedule = build(:schedule, day_of_week: nil)
    schedule.valid?
    expect(schedule.errors[:day_of_week]).to include("no puede estar en blanco")
  end
end