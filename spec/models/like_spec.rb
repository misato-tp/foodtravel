require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:restaurant1) { create(:restaurant) }
  let(:restaurant2) { create(:restaurant) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  context 'いいねができる場合' do
    it 'いいねが有効であること' do
      like1 = create(:like, user: user1, restaurant: restaurant1)
      expect(like1).to be_valid
    end

    it '1人のuserが複数のrestaurantにいいねができること' do
      like1 = create(:like, user: user1, restaurant: restaurant1)
      like2 = create(:like, user: user1, restaurant: restaurant2)
      expect(like1).to be_valid
      expect(like2).to be_valid
    end

    it '複数のuserが1つのrestaurantにいいねができること' do
      like1 = create(:like, user: user1, restaurant: restaurant1)
      like2 = create(:like, user: user2, restaurant: restaurant1)
      expect(like1).to be_valid
      expect(like2).to be_valid
    end
  end

  context 'いいねができない場合' do
    it 'userがない場合はいいねができないこと' do
      like1 = build(:like, user: nil, restaurant: restaurant1)
      expect(like1).not_to be_valid
    end

    it 'restaurantがない場合はいいねができないこと' do
      like1 = build(:like, user: user1, restaurant: nil)
      expect(like1).not_to be_valid
    end
  end
end
