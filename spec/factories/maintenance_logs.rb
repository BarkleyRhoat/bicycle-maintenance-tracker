FactoryBot.define do
  factory :maintenance_log do
    bike
    service_date { Date.current }
    description { "Replaced chain" }
    km_at_service { 1200 }
  end
end
