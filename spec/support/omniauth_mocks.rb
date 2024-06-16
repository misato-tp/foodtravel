module OmniauthMacros
  def google_mock
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      {
        "provider" => "google_oauth2",
        "uid" => "100000000000000000000",
        "info" => {
          "name" => "auth_user",
          "email" => "auth@email.com",
        },
        "credentials" => {
          "token" => "TOKEN",
          "refresh_token" => "REFRESH_TOKEN",
          "expires_at" => 1496120719,
          "expires" => true
        },
        "extra" => {
          "id_token" => "ID_TOKEN",
          "id_info" => {
            "azp" => "APP_ID",
            "aud" => "APP_ID",
            "sub" => "100000000000000000000",
            "email" => "auth@email.com",
            "email_verified" => true,
            "at_hash" => "HK6E_P6Dh8Y93mRNtsDB1Q",
            "iss" => "accounts.google.com",
            "iat" => 1496117119,
            "exp" => 1496120719
          },
          "raw_info" => {
            "sub" => "100000000000000000000",
            "name" => "auth_user",
            "email" => "auth@email.com",
            "email_verified" => "true",
            "locale" => "ja",
          }
        }
      }
    )
  end
end