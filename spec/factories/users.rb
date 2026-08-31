FactoryBot.define do
  factory :user do
    name { "Jane Rider" }
    email { "jane@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
