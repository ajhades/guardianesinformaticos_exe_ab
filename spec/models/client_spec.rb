require 'rails_helper'

RSpec.describe Client, type: :model do
  it "has a valid factory" do
    expect(create(:client)).to be_valid
  end

  it "is invalid without a name" do
    client = build(:client, name: nil)
    client.valid?
    expect(client.errors[:name]).to include("no puede estar en blanco")
  end
end