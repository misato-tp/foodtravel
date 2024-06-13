require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:restaurant1) { create(:restaurant, user: user) }
  let(:restaurant2) { create(:restaurant, user: user) }
  let(:like1) { create(:like, user: user) }
  let(:like2) { create(:like, user: user) }
  let(:report1) { create(:report, user: user) }
  let(:report2) { create(:report, user: user) }
  let(:auth) { create(:auth_hash) }
  
  describe 'バリデーションに関するテスト' do
    context '登録に成功する場合' do
      it 'username, email, password, password_confirmationが正しく入力されていると登録ができること' do
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

      it 'すでに登録されているemailでは登録に失敗すること' do
        same_email_user = create(:user, email: 'tests@email.com')
        user = build(:user, email: 'tests@email.com')
        user.valid?
        expect(user.errors[:email]).to include('は既に使用されています。')
      end

      it 'パスワードが6文字以下だと登録に失敗すること' do
        user = build(:user, password: '12345')
        user.valid?
        expect(user.errors[:password]).to include('は6文字以上に設定して下さい。')
      end

      it 'パスワードと確認用パスワードが一致していないと登録に失敗すること' do
        user = build(:user, password: 'password', password_confirmation: 'passward')
        user.valid?
        expect(user.errors[:password_confirmation]).to include('が内容とあっていません。')
      end

      it 'googleアカウントでログインしたことがあり、そのgoogleアカウントのemailを使用し登録すると失敗すること' do
        User.from_omniauth(auth)
        user = build(:user, email: 'auth@email.com')
        user.valid?
        expect(user.errors[:email]).to include('は既に使用されています。')
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

  describe 'googleアカウントのログインに関するテスト' do
    context '成功する場合' do
      it '初ログインで、googleの情報を使って新しくユーザーが作られること' do
        expect { User.from_omniauth(auth) }.to change{ User.count }.by(1)
      end

      context '2回目以降同じgoogleアカウントを使ってログインした場合' do
        it '同じアカウントで2回目以降ログインしてもユーザーは増えないこと' do
          User.from_omniauth(auth)
          expect { User.from_omniauth(auth) }.not_to change { User.count }
        end
      end
    end

    context '失敗する場合' do
      it 'usernameの情報が無いとアカウントが作成できないこと' do
        auth = build(:auth_hash, info: { name: nil })
        expect { User.from_omniauth(auth) }.not_to change{ User.count }
      end

      it  'emailの情報が無いとアカウントが作成できないこと' do
        auth = build(:auth_hash, info: {email: nil })
        expect { User.from_omniauth(auth) }.not_to change{ User.count }
      end
    end
  end

  describe 'ゲストログインに関するテスト' do
    it 'ゲストユーザーが存在しない場合は新しいゲストユーザーが作成されること' do
      expect { User.guest }.to change{ User.count }.by(1)
    end

    it '2回目以降は同じゲストユーザーでログインされること' do
      User.guest
      expect { User.guest }.not_to change { User.count }
    end
  end

  describe 'いいね機能に関するテスト' do
    it 'userが指定されたrestaurantをいいねしていればtrueが返ってくること' do
      user.likes.create(restaurant_id: restaurant1.id)
      expect(user.liked_by?(restaurant1.id)).to eq(true)
    end

    it 'userが指定されたrestaurantをいいねしていなければfalseが返ってくること' do
      expect(user.liked_by?(restaurant1.id)).to eq(false)
    end
  end
end
