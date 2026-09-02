require "rails_helper"

RSpec.describe "Bikes", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, email: "other@example.com") }

  describe "when not logged in" do
    it "redirects GET / to /login" do
      get root_path
      expect(response).to redirect_to(login_path)
    end

    it "redirects GET /bikes to /login" do
      get bikes_path
      expect(response).to redirect_to(login_path)
    end

    it "redirects GET /bikes/new to /login" do
      get new_bike_path
      expect(response).to redirect_to(login_path)
    end

    it "redirects POST /bikes to /login" do
      post bikes_path, params: { bike: { name: "Allez", brand: "Specialized" } }
      expect(response).to redirect_to(login_path)
    end
  end

  describe "when logged in" do
    before do
      post login_path, params: { email: user.email, password: user.password }
    end

    describe "GET /bikes" do
      it "displays the user's bikes and welcome message" do
        bike = create(:bike, user: user, name: "Tarmac SL7", brand: "Specialized")
        get bikes_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Welcome, #{user.name}")
        expect(response.body).to include(bike.name)
        expect(response.body).to include(bike.brand)
      end

      it "does not display bikes belonging to other users" do
        other_bike = create(:bike, user: other_user, name: "Secret Bike", brand: "Trek")
        get bikes_path

        expect(response.body).not_to include(other_bike.name)
      end

      it "displays an empty state message when user has no bikes" do
        get bikes_path
        expect(response.body).to include("You have not added any bikes yet.")
      end
    end

    describe "GET /bikes/:id" do
      it "displays the bike details" do
        bike = create(:bike, user: user, name: "Domane SL6", brand: "Trek")
        get bike_path(bike)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Domane SL6")
        expect(response.body).to include("Trek")
      end

      it "redirects to root with an alert when attempting to view another user's bike" do
        other_bike = create(:bike, user: other_user)
        get bike_path(other_bike)

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Record not found.")
      end
    end

    describe "POST /bikes" do
      it "creates a new bike for the current user" do
        expect do
          post bikes_path, params: { bike: { name: "Checkpoint ALR", brand: "Trek" } }
        end.to change(user.bikes, :count).by(1)

        expect(response).to redirect_to(bike_path(user.bikes.last))
        follow_redirect!
        expect(response.body).to include("Bike added successfully.")
      end

      it "renders new with errors on invalid input" do
        post bikes_path, params: { bike: { name: "", brand: "" } }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("error")
      end
    end

    describe "PATCH /bikes/:id" do
      it "updates the bike with valid attributes" do
        bike = create(:bike, user: user, name: "Old Name")
        patch bike_path(bike), params: { bike: { name: "New Name", brand: "Specialized" } }

        expect(response).to redirect_to(bike_path(bike))
        follow_redirect!
        expect(response.body).to include("Bike updated successfully.")
        expect(bike.reload.name).to eq("New Name")
      end

      it "renders edit with errors on invalid attributes" do
        bike = create(:bike, user: user)
        patch bike_path(bike), params: { bike: { name: "", brand: "" } }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("error")
      end
    end

    describe "DELETE /bikes/:id" do
      it "deletes the bike and redirects to bikes index" do
        bike = create(:bike, user: user)

        expect do
          delete bike_path(bike)
        end.to change(user.bikes, :count).by(-1)

        expect(response).to redirect_to(bikes_path)
        follow_redirect!
        expect(response.body).to include("Bike deleted successfully.")
      end
    end
  end
end
