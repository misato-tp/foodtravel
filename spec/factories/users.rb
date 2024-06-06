FactoryBot.define do
  factory :user do
    email { "test@email" }
    username { "testuser" }
    profile_image { [ Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.jpg'), 'image/jpeg') ] }
    password { "password" }
    password_confirmation { "password" }
  end
end
