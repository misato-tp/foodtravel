class Restaurant < ApplicationRecord
  validates :name, :address, presence: true
  validate :address_uniqueness_check

  def address_uniqueness_check
    #addressが空欄でないことと、今のレコード(id: id)を除いて、Restaurantテーブルのレコード全てに対して、同じaddressがないかを確認する
    if address.present? && Restaurant.where.not(id: id).exists?(address: address)
      errors.add(:address, "はすでに登録されているようです。お店を探してレポを書こう！")
    end
  end
end
