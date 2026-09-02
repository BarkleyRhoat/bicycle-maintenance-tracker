FactoryBot.define do
  factory :bike_component do
    bike
    component { association :component, user: bike.user }
    installed_on { Date.current }
    current_km { 150 }
  end
end
