class Restaurant < ApplicationRecord
  with_options presence: true do
    validates :name, :postal_code, :prefecture_code, :city, :street
  end
  validate :address_uniqueness_check

  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :reports, dependent: :destroy

  def address_uniqueness_check
    #addressが空欄でないことと、今のレコード(id: id)を除いて、Restaurantテーブルのレコード全てに対して、同じaddressがないかを確認する
    if address.present? && Restaurant.where.not(id: id).exists?(address: address)
      errors.add(:address, "はすでに登録されているようです。お店を探してレポを書こう！")
    end
  end
end
