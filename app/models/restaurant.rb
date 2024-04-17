class Restaurant < ApplicationRecord
  with_options presence: true do
    validates :postal_code, :prefecture_code, :city, :street
  end
  validate :name_uniqueness_check

  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :reports, dependent: :destroy

  def name_uniqueness_check
    #nameが空欄でないことと、今のレコード(id: id)を除いて、Restaurantテーブルのレコード全てに対して、同じnameがないかを確認する
    if name.present? && Restaurant.where.not(id: id).exists?(name: name)
      errors.add(:name, "はすでに登録されているようです。お店を探してレポを書こう！")
    end
  end
end
