class Restaurant < ApplicationRecord
  with_options presence: true do
    validates :name, :postal_code, :address
  end
  validate :name_uniqueness_check

#写真のアップロード
  mount_uploader :image, ImageUploader

#リレーションの設定
  belongs_to :user
  has_many :restaurant_country_relations
  has_many :counties, through: :restaurant_country_relations
  has_many :reports, dependent: :destroy
  
#住所の自動入力機能, 都道府県コードから都道府県名に自動で変換する
  include JpPrefecture
  jp_prefecture :prefecture_code

#GoogleMapsAPIの設定
geocoded_by :address
after_validation :geocode, if: :address_changed?

  def name_uniqueness_check
    #nameが空欄でないことと、今のレコード(id: id)を除いて、Restaurantテーブルのレコード全てに対して、同じnameがないかを確認する
    if name.present? && Restaurant.where.not(id: id).exists?(name: name)
      errors.add(:name, "はすでに登録されているようです。お店を探してレポを書こう！")
    end
  end
end
