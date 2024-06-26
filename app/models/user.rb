class User < ApplicationRecord
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, omniauth_providers: [:google_oauth2]

  validates :username, presence: true
  has_many :restaurants
  has_many :reports, dependent: :destroy
  has_many :likes, dependent: :destroy

  mount_uploader :profile_image, ImageUploader

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.username = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com', username: 'guest_user') do |user|
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def liked_by?(restaurant_id)
    likes.where(restaurant_id: restaurant_id).exists?
  end
end
