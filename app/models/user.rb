class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, omniauth_providers: [:google_oauth2]

  validates :username, presence: true
  has_many :restaurants
  has_many :reports, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.username = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com', username: 'guest_user') do |user|
      user.password = SecureRandom.urlsafe_base64
      #SecureRandom.urlsafe_base64はURLに使えるランダムな文字列を生成するメソッド。
    end
  end
end
