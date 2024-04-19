class Restaurant < ApplicationRecord
  with_options presence: true do
    validates :name, :postal_code, :prefecture_code, :city, :street
  end
  validate :name_uniqueness_check

#写真のアップロード
  mount_uploader :image, ImageUploader

#リレーションの設定
  belongs_to :user
  has_many :reports, dependent: :destroy
  
#住所の自動入力機能
  include JpPrefecture
  jp_prefecture :prefecture_code

#GoogleMapsAPIの設定
geocoded_by :combine_address
after_validation :geocode, if: :address_changed?

  def name_uniqueness_check
    #nameが空欄でないことと、今のレコード(id: id)を除いて、Restaurantテーブルのレコード全てに対して、同じnameがないかを確認する
    if name.present? && Restaurant.where.not(id: id).exists?(name: name)
      errors.add(:name, "はすでに登録されているようです。お店を探してレポを書こう！")
    end
  end

  def prefecture_name
    JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end

  def combine_address
    [prefecture_code, city, streer, other_address].compact.join(', ')
  end

  def address_changed?
    prefecture_code_changed? || city_canged? || street_changed? || other_address_changed?
  end
end
