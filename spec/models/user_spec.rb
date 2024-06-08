require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  
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
end
