require "rails_helper"

RSpec.describe "MaintenanceLogs", type: :request do
  let(:user) { create(:user) }
  let(:bike) { create(:bike, user: user) }
  let(:component) { create(:component, user: user) }

  before do
    create(:bike_component, bike: bike, component: component)
    post login_path, params: { email: user.email, password: user.password }
  end

  describe "POST /bikes/:bike_id/maintenance_logs" do
    it "creates a log with a component installed on the bike" do
      expect do
        post bike_maintenance_logs_path(bike), params: {
          maintenance_log: {
            service_date: Date.current,
            description: "Replaced chain",
            km_at_service: 1200,
            component_id: component.id
          }
        }
      end.to change(MaintenanceLog, :count).by(1)

      expect(response).to redirect_to(bike_maintenance_log_path(bike, MaintenanceLog.last))
      follow_redirect!
      expect(response.body).to include("Log created successfully.")
    end

    it "renders new with errors when component is not installed on the bike" do
      other_component = create(:component, user: user)

      post bike_maintenance_logs_path(bike), params: {
        maintenance_log: {
          service_date: Date.current,
          description: "Replaced chain",
          km_at_service: 1200,
          component_id: other_component.id
        }
      }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("must be installed on this bike")
    end
  end

  describe "RecordNotFound handling" do
    it "redirects to root with an alert for a missing bike" do
      get bike_maintenance_logs_path(999_999)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Record not found.")
    end

    it "redirects to root with an alert for a missing maintenance log" do
      get bike_maintenance_log_path(bike, 999_999)

      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Record not found.")
    end
  end
end
