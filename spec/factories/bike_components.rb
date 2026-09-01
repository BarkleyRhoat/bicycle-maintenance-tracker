FactoryBot.define do
  factory :bike_component do
    bike
    component
    installed_on { Date.current }
    current_km { 150 }
  end
end
