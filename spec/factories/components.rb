FactoryBot.define do
  factory :component do
    user
    name { "Shimano CN-M8100 12-Speed Chain" }
    component_type { "Chain" }
    expected_lifespan_km { 3000 }
  end
end
