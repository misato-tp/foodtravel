FactoryBot.define do
  factory :report do
    title { "テストレポート1" }
    image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.jpg'), 'image/jpeg') }
    recommend { "おすすめ料理" }
    memo { "テストメモ" }
    association :user
    association :restaurant
  end
end
