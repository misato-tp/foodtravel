require 'securerandom'

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@email.com" }
    username { "testuser" }
    profile_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/test.jpg'), 'image/jpeg') }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :auth_hash, class: OmniAuth::AuthHash do
    provider { "google" }
    uid { 123456789012345678901 }
    info do
      {
        name: "auth_user",
        email: "auth@email.com"
      }
    end
  end
end
