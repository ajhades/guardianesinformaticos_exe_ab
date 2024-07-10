require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(create(:user)).to be_valid
  end

  it "is invalid without a first_name" do
    user = build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("no puede estar en blanco")
  end
end