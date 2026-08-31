require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with a name, email, and password" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "is invalid without a name" do
      user = build(:user, name: nil)
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "is invalid without an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "requires a unique email" do
      create(:user)
      user = build(:user, email: "jane@example.com")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "requires a password of at least 6 characters" do
      user = build(:user, password: "short", password_confirmation: "short")
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it "requires password confirmation to match" do
      user = build(:user, password_confirmation: "different")
      expect(user).not_to be_valid
    end
  end

  describe "authentication" do
    it "authenticates with the correct password" do
      user = create(:user)
      expect(user.authenticate("password123")).to eq(user)
    end

    it "does not authenticate with the wrong password" do
      user = create(:user)
      expect(user.authenticate("wrongpassword")).to be false
    end
  end
end
