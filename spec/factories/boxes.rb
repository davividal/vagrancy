FactoryBot.define do
  factory :box do
    organization
    name { Faker.App.name.downcase }
  end
end
