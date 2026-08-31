require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /signup" do
    it "renders the signup form" do
      get signup_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sign Up")
    end
  end

  describe "POST /signup" do
    it "creates a new user and logs them in" do
      post signup_path, params: {
        user: {
          name: "Jane Rider",
          email: "jane@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Account created successfully")
      expect(session[:user_id]).to be_present
    end

    it "renders the signup form with errors for invalid data" do
      post signup_path, params: {
        user: {
          name: "",
          email: "",
          password: "",
          password_confirmation: ""
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("error")
    end
  end
end
