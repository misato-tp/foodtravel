require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  let(:restaurant) { create(:restaurant) }
  let(:report1) { create(:report, restaurant: restaurant) }
  let(:report2) { create(:report, restaurant: restaurant) }
  let(:like1) { create(:like, restaurant: restaurant) }
  let(:like2) { create(:like, restaurant: restaurant) }

  describe 'バリデーションに関するテスト' do
    context '投稿可能な場合' do
      it 'imageとmemoがなくても登録が有効であること' do
        restaurant = build(:restaurant, image: nil, memo: nil)
        expect(restaurant).to be_valid
      end
    end

    context '投稿不可能な場合' do
      it 'nameなしでは登録が無効であること' do
      restaurant = build(:restaurant, name: nil)
      restaurant.valid?
      expect(restaurant.errors[:name]).to include('を入力してください')
      end

      it 'postal_codeなしでは登録が無効であること' do
        restaurant = build(:restaurant, postal_code: nil)
        restaurant.valid?
        expect(restaurant.errors[:postal_code]).to include('を入力してください')
      end

      it 'addressなしでは登録が無効であること' do
        restaurant = build(:restaurant, address: nil)
        restaurant.valid?
        expect(restaurant.errors[:address]).to include('を入力してください')
      end

      it 'nameが重複していると登録ができないこと' do
        create(:restaurant)
        restaurant2 = build(:restaurant)
        restaurant2.valid?
        expect(restaurant2.errors[:name]).to include('はすでに登録されているようです。お店を探してレポを書こう！')
      end
    end
  end

  describe 'リレーションに関するテスト' do
    it 'userなしでは登録ができないこと' do
      restaurant = build(:restaurant, user: nil)
      restaurant.valid?
      expect(restaurant.errors[:user]).to include('を入力してください')
    end

    it 'countryなしでは登録ができないこと' do
      restaurant = build(:restaurant, country: nil)
      restaurant.valid?
      expect(restaurant.errors[:country]).to include('を入力してください')
    end

    it 'restaurantが複数のレポートを取得できること' do
      expect(restaurant.reports).to include(report1, report2)
    end
    
    it 'restaurantが複数のいいねを取得できること' do
      expect(restaurant.likes).to include(like1, like2)
    end
  end
end
