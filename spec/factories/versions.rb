FactoryBot.define do
  factory :version do
    box
    version { Faker::App.semantic_version }
  end
end
