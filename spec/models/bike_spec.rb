require "rails_helper"

RSpec.describe Bike, type: :model do
  describe "associations" do
    it "belongs to a user" do
      user = create(:user)
      bike = create(:bike, user: user)
      expect(bike.user).to eq(user)
    end
  end

  describe "validations" do
    it "is valid with a name, brand, and user" do
      bike = build(:bike)
      expect(bike).to be_valid
    end

    it "is invalid without a name" do
      bike = build(:bike, name: nil)
      expect(bike).not_to be_valid
      expect(bike.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a brand" do
      bike = build(:bike, brand: nil)
      expect(bike).not_to be_valid
      expect(bike.errors[:brand]).to include("can't be blank")
    end

    it "is invalid without an associated user" do
      bike = build(:bike, user: nil)
      expect(bike).not_to be_valid
      expect(bike.errors[:user]).to include("must exist")
    end
  end

  describe "dependent destruction" do
    it "is destroyed when the associated user is destroyed" do
      user = create(:user)
      create(:bike, user: user)

      expect { user.destroy }.to change(described_class, :count).by(-1)
    end
  end
end
