FactoryBot.define do
  factory :restaurant do
    sequence(:name) { |n| "テスト#{n}のお店" }
    postal_code { "1000000" }
    address { "東京都千代田区" }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.jpg'), 'image/jpeg') }
    latitude { "35.685780" }
    longitude { "139.744959" }
    memo { "テストです" }
    association :user
    association :country
  end
end
