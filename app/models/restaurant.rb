class Restaurant < ApplicationRecord
  with_options presence: true do
    validates :postal_code, :prefecture_code, :city, :street
  end
  validate :name_uniqueness_check

  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :reports, dependent: :destroy
  include JpPrefecture
  jp_prefecture :prefecture_code

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
end
