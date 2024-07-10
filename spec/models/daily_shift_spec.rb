require 'rails_helper'

RSpec.describe DailyShift, type: :model do
  it "has a valid factory" do
    expect(create(:daily_shift)).to be_valid
  end

  it "is invalid without a week" do
    daily_shift = build(:daily_shift, week: nil)
    daily_shift.valid?
    expect(daily_shift.errors[:week]).to include("no puede estar en blanco")
  end
end