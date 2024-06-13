FactoryBot.define do
  factory :like do
    association :restaurant
    association :user
  end
end
