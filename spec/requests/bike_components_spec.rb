require "rails_helper"

RSpec.describe "BikeComponents", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:bike) { create(:bike, user: user) }
  let(:component) { create(:component, user: user) }


  describe "when not logged in" do
    it "redirects all bike component requests to /login" do
      aggregate_failures do
        get new_bike_bike_component_path(bike)
        expect(response).to redirect_to(login_path)

        post bike_bike_components_path(bike), params: {
          bike_component: { component_id: component.id, installed_on: Date.current, current_km: 10 }
        }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "when logged in" do
    before do
      post login_path, params: { email: user.email, password: user.password }
    end

    describe "GET /bikes/:bike_id/bike_components/new" do
      it "renders the install component form with available components" do
        component # force creation before rendering the form
        get new_bike_bike_component_path(bike)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Install Component")
        expect(response.body).to include(component.name)
      end
    end

    describe "POST /bikes/:bike_id/bike_components" do
      it "installs a component on the bike with valid parameters" do
        expect do
          post bike_bike_components_path(bike), params: {
            bike_component: {
              component_id: component.id,
              installed_on: Date.current,
              current_km: 250
            }
          }
        end.to change(bike.bike_components, :count).by(1)

        expect(response).to redirect_to(bike_path(bike))
        follow_redirect!
        expect(response.body).to include("Component installed successfully.")
        expect(bike.components).to include(component)
      end

      it "renders the form with errors for invalid input" do
        post bike_bike_components_path(bike), params: {
          bike_component: { component_id: component.id, installed_on: nil, current_km: -1 }
        }

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("error")
      end

      it "prevents installing the same component on a second bike" do
        bike1 = create(:bike, user: user)
        bike2 = create(:bike, user: user)
        component = create(:component, user: user)
        create(:bike_component, bike: bike1, component: component)
      
        expect do
          post bike_bike_components_path(bike2), params: {
            bike_component: {
              component_id: component.id,
              installed_on: Date.current,
              current_km: 50
            }
          }
        end.not_to change(BikeComponent, :count)
      
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("is already installed on a bike")
      end
    end

    describe "DELETE /bikes/:bike_id/bike_components/:id" do
      it "removes the component from the bike without deleting the component" do
        bike_component = create(:bike_component, bike: bike, component: component)

        expect do
          delete bike_bike_component_path(bike, bike_component)
        end.to change(BikeComponent, :count).by(-1).and change(Component, :count).by(0)

        expect(response).to redirect_to(bike_path(bike))
        follow_redirect!
        expect(response.body).to include("Component removed successfully.")
      end
    end

    describe "authorization" do
      it "redirects to root with an alert when installing a component on another user's bike" do
        other_bike = create(:bike, user: other_user)

        post bike_bike_components_path(other_bike), params: {
          bike_component: {
            component_id: component.id,
            installed_on: Date.current,
            current_km: 10
          }
        }

        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Record not found.")
      end

      it "does not allow installing another user's component on the current user's bike" do
        other_component = create(:component, user: other_user)

        expect do
          post bike_bike_components_path(bike), params: {
            bike_component: {
              component_id: other_component.id,
              installed_on: Date.current,
              current_km: 10
            }
          }
        end.not_to change(BikeComponent, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("must belong to the bike owner")
      end
    end

    describe "bike show page display" do
      it "displays installed components with install details" do
        bike_component = create(:bike_component, bike: bike, component: component)
        get bike_path(bike)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include(bike_component.component.name)
        expect(response.body).to include(bike_component.component.component_type)
        expect(response.body).to include(bike_component.current_km.to_s)
      end

      it "displays empty state when bike has no installed components" do
        get bike_path(bike)
        expect(response.body).to include("No components installed yet.")
      end
    end
  end
end
