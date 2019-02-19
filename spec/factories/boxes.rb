FactoryBot.define do
  factory :box do
    user
    name { Faker.App.name.downcase }
  end
end
