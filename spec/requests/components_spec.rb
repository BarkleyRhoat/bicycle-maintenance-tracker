require "rails_helper"

RSpec.describe "Components", type: :request do
  let(:user) { create(:user) }

  describe "when not logged in" do
    it "redirects GET /components to /login" do
      get components_path
      expect(response).to redirect_to(login_path)
    end

    it "redirects GET /components/new to /login" do
      get new_component_path
      expect(response).to redirect_to(login_path)
    end

    it "redirects POST /components to /login" do
      post components_path, params: {
        component: { name: "Chain", component_type: "Chain", expected_lifespan_km: 3000 }
      }
      expect(response).to redirect_to(login_path)
    end
  end

  describe "when logged in" do
    before do
      post login_path, params: { email: user.email, password: user.password }
    end

    describe "GET /components" do
      it "displays the list of components" do
        component = create(:component, name: "Shimano Chain", component_type: "Chain", expected_lifespan_km: 3000)
        get components_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(component.name)
        expect(response.body).to include("Chain")
        expect(response.body).to include("3000 km")
      end

      it "displays an empty state message when no components exist" do
        get components_path
        expect(response.body).to include("No components have been added yet.")
      end

      it "shows My Bikes link in the navigation header" do
        get components_path
        expect(response.body).to include("My Bikes")
      end
    end

    describe "GET /components/:id" do
      it "displays component details" do
        component = create(:component, name: "Continental GP5000", component_type: "Tires", expected_lifespan_km: 5000)
        get component_path(component)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Continental GP5000")
        expect(response.body).to include("Tires")
        expect(response.body).to include("5000 km")
      end
    end

    describe "POST /components" do
      it "creates a new component with valid parameters" do
        expect do
          post components_path, params: {
            component: {
              name: "SRAM Eagle Cassette",
              component_type: "Cassette",
              expected_lifespan_km: 6000
            }
          }
        end.to change(Component, :count).by(1)

        expect(response).to redirect_to(component_path(Component.last))
        follow_redirect!
        expect(response.body).to include("Component created successfully.")
      end

      it "renders new with errors on invalid input" do
        post components_path, params: {
          component: { name: "", component_type: "", expected_lifespan_km: 0 }
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("error")
      end
    end

    describe "PATCH /components/:id" do
      it "updates the component with valid attributes" do
        component = create(:component, name: "Old Name")
        patch component_path(component), params: {
          component: { name: "Updated Chain", component_type: "Chain", expected_lifespan_km: 3500 }
        }

        expect(response).to redirect_to(component_path(component))
        follow_redirect!
        expect(response.body).to include("Component updated successfully.")
        expect(component.reload.name).to eq("Updated Chain")
      end

      it "renders edit with errors on invalid input" do
        component = create(:component)
        patch component_path(component), params: {
          component: { name: "", component_type: "", expected_lifespan_km: -10 }
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("error")
      end
    end

    describe "DELETE /components/:id" do
      it "deletes the component and redirects to components index" do
        component = create(:component)

        expect do
          delete component_path(component)
        end.to change(Component, :count).by(-1)

        expect(response).to redirect_to(components_path)
        follow_redirect!
        expect(response.body).to include("Component deleted successfully.")
      end
    end
  end
end
