FactoryBot.define do
  factory :organization do
    name { Faker::Internet.username }
  end
end
