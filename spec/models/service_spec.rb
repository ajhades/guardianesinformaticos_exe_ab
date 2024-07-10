require 'rails_helper'

RSpec.describe Service, type: :model do
  it "has a valid factory" do
    expect(create(:service)).to be_valid
  end

  it "is invalid without a name" do
    service = build(:service, name: nil)
    service.valid?
    expect(service.errors[:name]).to include("no puede estar en blanco")
  end
end