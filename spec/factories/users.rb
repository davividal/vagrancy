FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    password { Faker::Internet.password }
    email { Faker::Internet.email }
    salt { Faker::Internet.password }
  end
end
