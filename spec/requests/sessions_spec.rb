require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "renders the login form" do
      get login_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Log In")
    end
  end

  describe "POST /login" do
    let!(:user) { create(:user, email: "jane@example.com", password: "password123") }

    it "logs in a user with valid credentials" do
      post login_path, params: { email: "jane@example.com", password: "password123" }

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Logged in successfully")
      expect(session[:user_id]).to eq(user.id)
    end

    it "renders the login form with an error for invalid credentials" do
      post login_path, params: { email: "jane@example.com", password: "wrong" }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Invalid email or password")
    end
  end

  describe "DELETE /logout" do
    it "logs out the current user" do
      user = create(:user)
      post login_path, params: { email: user.email, password: user.password }

      delete logout_path

      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include("Logged out successfully")
      expect(session[:user_id]).to be_nil
    end
  end
end
