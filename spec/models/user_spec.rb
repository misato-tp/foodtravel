require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:restaurant1) { create(:restaurant, user: user) }
  let(:restaurant2) { create(:restaurant, user: user) }
  let(:like1) { create(:like, user: user) }
  let(:like2) { create(:like, user: user) }
  let(:report1) { create(:report, user: user) }
  let(:report2) { create(:report, user: user) }
  
  describe 'バリデーションに関するテスト' do
    context '登録に成功する場合' do
      it 'username, email, password, password_confirmationがあれば登録ができること' do
        user.profile_image = nil
        expect(user).to be_valid
      end
    end

    context '登録に失敗する場合' do
      it 'usernameが空だと登録に失敗すること' do
        user = build(:user, username: nil)
        user.valid?
        expect(user.errors[:username]).to include('を入力してください')
      end

      it 'emailが空だと登録に失敗すること' do
        user = build(:user, email: '')
        user.valid?
        expect(user.errors[:email]).to include('を入力してください')
      end

      it 'passwordが空だと登録に失敗すること' do
        user = build(:user, password: '')
        user.valid?
        expect(user.errors[:password]).to include('を入力してください')
      end

      it 'password_confirmationが空だと登録に失敗すること' do
        user = build(:user, password_confirmation: '')
        user.valid?
        expect(user.errors[:password_confirmation]).to include('が内容とあっていません。')
      end
    end
  end

  describe 'リレーションに関するテスト' do
    it 'userは複数のrestaurantを取得できること' do
      expect(user.restaurants).to include(restaurant1, restaurant2)
    end

    it 'userは複数のreportを取得できること' do
      expect(user.reports).to include(report1, report2)
    end

    it 'userは複数のlikeを取得できること' do
      expect(user.likes).to include(like1, like2)
    end

    it 'userを削除すると、reportも削除されること' do
      user = create(:user, reports: [report1, report2])
      expect{ user.destroy }.to change{ Report.count }.by(-2)
    end

    it 'userを削除すると、likeも削除されること' do
      like1 = create(:like, user: user)
      expect{ user.destroy }.to change{ Like.count }.by(-1)
    end
  end
end
