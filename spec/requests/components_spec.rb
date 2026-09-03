require "rails_helper"

RSpec.describe "Components", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, email: "other@example.com") }

  describe "when not logged in" do
    it "redirects all component requests to /login" do
      aggregate_failures do
        get components_path
        expect(response).to redirect_to(login_path)

        get new_component_path
        expect(response).to redirect_to(login_path)

        post components_path, params: {
          component: { name: "Chain", component_type: "Chain", expected_lifespan_km: 3000 }
        }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "when logged in" do
    before do
      post login_path, params: { email: user.email, password: user.password }
    end

    describe "GET /components" do
      it "displays the user's components and hides other users' components" do
        component = create(
          :component,
          name: "Shimano Chain",
          component_type: "Chain",
          expected_lifespan_km: 3000,
          user: user
        )
        other_component = create(:component, name: "Secret Chain", user: other_user)
        get components_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(component.name)
          expect(response.body).to include("Chain")
          expect(response.body).to include("3000 km")
          expect(response.body).not_to include(other_component.name)
        end
      end

      it "displays an empty state message when no components exist" do
        get components_path
        expect(response.body).to include("No components have been added yet.")
      end

    end

    describe "GET /components/:id" do
      it "displays component details" do
        component = create(
          :component,
          name: "Continental GP5000",
          component_type: "Tires",
          expected_lifespan_km: 5000,
          user: user
        )
        get component_path(component)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Continental GP5000")
        expect(response.body).to include("Tires")
        expect(response.body).to include("5000 km")
      end

      it "redirects to root when attempting to view another user's component" do
        other_component = create(:component, name: "Secret Chain", user: other_user)
        get component_path(other_component)

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Record not found.")
      end

      it "displays associated maintenance logs" do
        component = create(:component, user: user)
        bike = create(:bike, user: user)
        create(:bike_component, bike: bike, component: component)
        create(
          :maintenance_log,
          bike: bike,
          component: component,
          service_date: Date.new(2025, 8, 15),
          description: "Cleaned and lubed",
          km_at_service: 800
        )

        get component_path(component)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Maintenance History")
        expect(response.body).to include("August 15, 2025")
        expect(response.body).to include("Cleaned and lubed")
        expect(response.body).to include("800")
        expect(response.body).to include(bike.name)
      end

      it "displays an empty state when no maintenance logs exist" do
        component = create(:component, user: user)
        get component_path(component)

        expect(response.body).to include("No maintenance logs for this component yet.")
      end

      it "does not display bikes or maintenance logs belonging to other users" do
        component = create(:component, user: user)
        bike = create(:bike, name: "My Bike", user: user)
        other_bike = create(:bike, name: "Other Bike", user: other_user)
        create(:bike_component, bike: bike, component: component)

        cross_user_install = BikeComponent.new(
          bike: other_bike,
          component: component,
          installed_on: Date.current,
          current_km: 100
        )
        cross_user_install.save(validate: false)

        cross_user_log = MaintenanceLog.new(
          bike: other_bike,
          component: component,
          service_date: Date.current,
          description: "Other user service",
          km_at_service: 100
        )
        cross_user_log.save(validate: false)

        get component_path(component)

        expect(response.body).to include(bike.name)
        expect(response.body).not_to include(other_bike.name)
        expect(response.body).not_to include(cross_user_log.description)
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
        component = create(:component, name: "Old Name", user: user)
        patch component_path(component), params: {
          component: { name: "Updated Chain", component_type: "Chain", expected_lifespan_km: 3500 }
        }

        expect(response).to redirect_to(component_path(component))
        follow_redirect!
        expect(response.body).to include("Component updated successfully.")
        expect(component.reload.name).to eq("Updated Chain")
      end

      it "renders edit with errors on invalid input" do
        component = create(:component, user: user)
        patch component_path(component), params: {
          component: { name: "", component_type: "", expected_lifespan_km: -10 }
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("error")
      end

      it "does not allow updating another user's component" do
        other_component = create(:component, name: "Old Name", user: other_user)
        patch component_path(other_component), params: {
          component: { name: "Hacked Chain", component_type: "Chain", expected_lifespan_km: 3500 }
        }

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Record not found.")
        expect(other_component.reload.name).to eq("Old Name")
      end
    end

    describe "DELETE /components/:id" do
      it "deletes the component and redirects to components index" do
        component = create(:component, user: user)

        expect do
          delete component_path(component)
        end.to change(Component, :count).by(-1)

        expect(response).to redirect_to(components_path)
        follow_redirect!
        expect(response.body).to include("Component deleted successfully.")
      end

      it "does not allow deleting another user's component" do
        other_component = create(:component, user: other_user)

        expect do
          delete component_path(other_component)
        end.not_to change(Component, :count)

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Record not found.")
      end
    end
  end
end
