class Restaurant < ApplicationRecord
  with_options presence: true do
    validates :name, :postal_code, :address
  end
  validate :name_uniqueness_check

  mount_uploader :image, ImageUploader

  belongs_to :user
  belongs_to :country
  has_many :reports, dependent: :destroy
  has_many :likes, dependent: :destroy

  include JpPrefecture
  jp_prefecture :prefecture_code

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def name_uniqueness_check
    if name.present? && Restaurant.where.not(id: id).exists?(name: name)
      errors.add(:name, "はすでに登録されているようです。お店を探してレポを書こう！")
    end
  end
end
