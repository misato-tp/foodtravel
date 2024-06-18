require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let(:restaurant) { create(:restaurant, user: user) }
  let(:report) { create(:report, restaurant: restaurant, user: user) }

  describe 'ログイン・ログアウトに関するテスト' do
    it 'ユーザーがユーザー名とパスワードでログインできること' do
      create(:user)
      visit new_user_session_path
      fill_in 'ユーザー名', with: 'testuser'
      fill_in 'パスワード', with: 'password'
      click_button 'ログイン'
      expect(page).to have_content 'ログインしました。'
      expect(page).to have_current_path(root_path)
    end

    it 'ログアウトができること' do
      login_as user
      visit root_path
      find('.dropdown-menu').click
      click_on 'ログアウト'
      expect(page).to have_current_path(root_path)
      expect(page).to have_content 'ログアウトしました。'
    end

    it 'ゲストユーザーでログインができること', js: true do
      visit new_user_session_path
      find('.guestLogin').click
      expect(page).to have_content 'ゲストユーザーとしてログインしました。'
      expect(page).to have_current_path(root_path)
    end

    it 'googleアカウントでログインできること', js: true do
      google_mock
      visit new_user_session_path
      find('.googleLogin').click
      expect(page).to have_content 'Google アカウントによる認証に成功しました。'
      expect(page).to have_current_path(root_path)
    end

    it 'ログインページから新規登録ページに遷移できること' do
      visit new_user_session_path
      click_on '新規登録はこちら'
      expect(page).to have_current_path(new_user_registration_path)
    end

    it 'ログイン画面からパスワード再発行のページに遷移できること' do
      visit new_user_session_path
      click_on 'ユーザー名・パスワードを忘れた方'
      expect(page).to have_current_path(new_user_password_path)
    end
  end

  describe '新規登録に関するテスト' do
    it 'ユーザーがユーザー名、アドレス、パスワードで新規登録ができること' do
      visit new_user_registration_path
      fill_in 'ユーザー名', with: 'new_user'
      fill_in 'メールアドレス', with: 'new@email.com'
      fill_in 'パスワード(6文字以上)', with: '123456'
      fill_in 'パスワード(確認用)', with: '123456'
      click_on '登録'
      expect(page).to have_content 'アカウント登録が完了しました。'
      expect(page).to have_current_path(root_path)
    end

    it 'googleで初回ログインの場合アカウントが新規作成されること', js: true do
      google_mock
      visit new_user_session_path
      expect do
        find('.googleLogin').click
        expect(page).to have_content 'Google アカウントによる認証に成功しました。'
      end.to change { User.count }.by(1)
    end

    it '2回目以降のgoogleアカウントによるログインの場合アカウントは新規作成されないこと', js: true do
      google_mock
      visit new_user_session_path
      find('.googleLogin').click
      find('li.nav-item.dropdown').click
      click_on 'ログアウト'
      click_on 'ログイン'
      expect do
        find('.googleLogin').click
      end.to change { User.count }.by(0)
    end
  end

  describe 'パスワード再発行に関するテスト' do
    it 'パスワード発行画面からログインページに遷移できること' do
      visit new_user_password_path
      click_on 'ユーザー名・パスワードを思い出した方はこちら'
      expect(page).to have_current_path(new_user_session_path)
    end

    it 'パスワード再発行画面から新規登録画面に遷移できること' do
      visit new_user_password_path
      click_on '新規登録はこちら'
      expect(page).to have_current_path(new_user_registration_path)
    end

    before do
      clear_emails
      visit new_user_password_path
      fill_in 'メールアドレス', with: user.email
      click_on '送信'
    end

    it '登録されているメールアドレスに再発行のメールを送ることができること' do
      expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします。'
      expect(page).to have_current_path(new_user_session_path)
      open_email(user.email)
      expect(current_email.subject).to eq 'パスワードの再設定について'
    end

    it '届いたメールアドレスからパスワード再登録のページに遷移できること' do
      open_email(user.email)
      current_email.click_link 'パスワードを変更する'
      expect(page).to have_content 'パスワードの再設定'
      expect(page).to have_current_path(/users\/password\/edit\?reset_password_token=.*/)
    end

    it 'パスワードの再登録ができること' do
      open_email(user.email)
      current_email.click_link 'パスワードを変更する'
      fill_in '新しいパスワード', with: '123456'
      fill_in '確認用パスワード', with: '123456'
      click_on 'パスワードを更新する'
      expect(page).to have_content 'パスワードが正しく変更されました。'
      expect(page).to have_current_path(root_path)
    end

    it 'パスワードの変更をしたらメールが届くこと' do
      open_email(user.email)
      current_email.click_link 'パスワードを変更する'
      fill_in '新しいパスワード', with: '123456'
      fill_in '確認用パスワード', with: '123456'
      click_on 'パスワードを更新する'
      open_email(user.email)
      expect(current_email.subject).to eq 'パスワードの変更について'
    end
  end

  describe 'いいねや投稿した情報に関するテスト' do
    before do
      login_as user
      visit root_path
    end

    context 'いいねしたお店がない場合' do
      it 'いいねしたお店ページにメッセージが出ること' do
        find('#navbarDropdown').click
        click_on 'いいねしたお店'
        expect(page).to have_content 'まだいいねしたお店はありません。'
      end
    end

    context 'いいねしたお店がある場合' do
      before do
        restaurant
        click_on 'お店を探す'
        click_on '詳細'
        find('.like-button').click
      end

      it 'いいねしたお店ページにお店の名前があること', js: true do
        find('#navbarDropdown').click
        click_on 'いいねしたお店'
        expect(page).to have_content(restaurant.name)
      end

      it 'お店の名前をクリックするとそのお店の詳細ページに遷移すること', js: true do
        find('#navbarDropdown').click
        click_on 'いいねしたお店'
        click_on(restaurant.name)
        expect(page).to have_current_path(restaurant_path(id: restaurant.id))
        expect(page).to have_content(restaurant.name)
      end
    end

    context '投稿したお店がない場合' do
      it '投稿したお店ページにメッセージが表示されること' do
        find('#navbarDropdown').click
        click_on '投稿したお店'
        expect(page).to have_content 'まだ投稿したお店はありません。'
      end
    end

    context '投稿したお店がある場合' do
      before do
        restaurant
      end

      it '投稿したお店ページにお店の名前があること' do
        find('#navbarDropdown').click
        click_on '投稿したお店'
        expect(page).to have_content(restaurant.name)
      end

      it 'お店の名前をクリックするとそのお店の詳細ページに遷移すること' do
        find('#navbarDropdown').click
        click_on '投稿したお店'
        click_on(restaurant.name)
        expect(page).to have_current_path(restaurant_path(id: restaurant.id))
      end
    end

    context '投稿したレポがない場合' do
      it '投稿したレポページにメッセージが表示されること' do
        find('#navbarDropdown').click
        click_on '投稿したレポ'
        expect(page).to have_content 'まだ投稿したレポはありません。'
      end
    end

    context '投稿したレポがある場合' do
      before do
        report
      end

      it '投稿したレポページにレポの題名が表示されること' do
        find('#navbarDropdown').click
        click_on '投稿したレポ'
        expect(page).to have_content(report.title)
      end

      it 'レポの題名をクリックするとそのレポが書かれているお店のページに遷移すること' do
        find('#navbarDropdown').click
        click_on '投稿したレポ'
        click_on(report.title)
        expect(page).to have_current_path(restaurant_path(id: restaurant.id))
      end
    end
  end

  describe 'profileページに関するテスト' do
    context 'アイコンを設定していない場合' do
      it 'ユーザーがprofile_imageをまだ設定していない場合、デフォルトの画像が設定されていること' do
        user2 = create(:user, profile_image: nil)
        login_as user2
        visit profile_users_path
        expect(page).to have_selector("img[src*='defaultIcon']")
      end
    end

    context 'アイコンが設定されている場合' do
      before do
        login_as user
        visit root_path
        find('#navbarDropdown').click
        click_on 'プロフィール'
      end

      it 'プロフィールページに詳細が全て表示されていること' do
        expect(page).to have_content(user.username)
        expect(page).to have_content(user.email)
        expect(page).to have_selector "img[src*='test.jpg']"
      end
    end

    context '編集ページに関するテストの場合' do
      before do
        login_as user
        visit root_path
        find('#navbarDropdown').click
        click_on 'プロフィール'
        click_on '編集'
      end

      it 'プロフィールページから編集ボタンを押すとページが遷移すること' do
        expect(page).to have_current_path(edit_user_registration_path)
      end

      it '一つ前に戻るボタンが正しく機能していること' do
        click_on '一つ前に戻る'
        expect(page).to have_current_path(profile_users_path)
      end

      it 'ユーザーの編集、更新ができること' do
        fill_in 'ユーザー名', with: '山田太郎'
        fill_in 'メールアドレス', with: 'yamada@email.com'
        attach_file('プロフィールアイコン', Rails.root.join('spec/fixtures/test2.jpg'))
        click_on '更新'
        expect(page).to have_content 'アカウント情報を変更しました。'
        expect(page).to have_current_path(profile_users_path)
        expect(page).to have_content '山田太郎'
        expect(page).to have_content 'yamada@email.com'
        expect(page).to have_selector "img[src*='test2.jpg']"
      end

      it 'プロフィールアイコンに新しい画像をアップロードするとプレビューが出ること', js: true do
        attach_file('プロフィールアイコン', Rails.root.join('spec/fixtures/test2.jpg'))
        expect(page).to have_selector 'img.preview-img'
      end

      it '編集ページに自分が設定したプロフィールアイコンがあればそれが表示されていること', js: true do
        attach_file('プロフィールアイコン', Rails.root.join('spec/fixtures/test2.jpg'))
        click_on '更新'
        click_on '編集'
        expect(page).to have_selector "img[src*='test2.jpg']"
      end
    end
  end

  describe 'アカウント削除に関するテスト' do
    before do
      login_as user
      visit profile_users_path
    end

    it 'アカウントを削除することができること', js: true do
      click_on '編集'
      expect do
        click_button '退会したい方はクリック'
        alert = page.driver.browser.switch_to.alert
        alert_text = alert.text.gsub(/\s+/, '')
        expected_text = "本当に削除してよろしいですか？なお、投稿したお店の情報はアカウントを削除しても残りますのでご注意ください。お店を削除したい場合はヘッダーのマイページ→投稿したお店→店名をクリック→上部にある「削除」ボタンを押してください。"
        expect(alert_text).to eq expected_text
        alert.accept
        expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
        expect(page).to have_current_path(root_path)
      end.to change { User.count }.by(-1)
    end
  end

  describe 'バリデーションやalertに関するテスト' do
    context 'ログインのフォームの場合' do
      before do
        visit new_user_session_path
      end

      it 'ユーザー名が空欄だとエラーになること' do
        fill_in 'ユーザー名', with: ''
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content 'ユーザー名 もしくはパスワードが不正です。'
      end

      it 'パスワードが空欄だとエラーになること' do
        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'パスワード', with: ''
        click_button 'ログイン'
        expect(page).to have_content 'ユーザー名 もしくはパスワードが不正です。'
      end

      it 'ユーザー名とパスワードが一致していないとエラーになること' do
        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'パスワード', with: '123456'
        click_button 'ログイン'
        expect(page).to have_content 'ユーザー名 もしくはパスワードが不正です。'
      end
    end

    context 'ログインページの場合' do
      it 'すでに登録されているアドレスのgoogleアカウントで新規登録をするとエラーになる', js: true do
        create(:user, email: 'auth@email.com')
        visit new_user_session_path
        find('.googleLogin').click
        expect(page).to have_content 'すでに同じアドレスのユーザーが登録されています。ユーザー名とパスワードでログインして下さい。'
      end
    end

    context 'パスワード再発行のフォームの場合' do
      before do
        visit new_user_password_path
      end

      it 'メールアドレス欄が空欄だとエラーになること' do
        fill_in 'メールアドレス', with: ''
        click_on '送信'
        expect(page).to have_content 'メールアドレスを入力してください'
      end

      it '登録されているメールアドレス以外のアドレスが入力されるとエラーが出ること' do
        fill_in 'メールアドレス', with: 'test@email.com'
        click_on '送信'
        expect(page).to have_content 'メールアドレスは見つかりませんでした。'
      end
    end

    context 'パスワード再設定のフォームの場合' do
      it 'トークンが入っていないURLにアクセスすると無効になること', js: true do
        visit edit_user_password_path
        expect(page).to have_content 'このページにはアクセスできません。パスワード再設定メールのリンクからアクセスされた場合には、URL をご確認ください。'
      end

      before do
        clear_emails
        user
        visit new_user_password_path
        fill_in 'メールアドレス', with: user.email
        click_on '送信'
        open_email(user.email)
        current_email.click_link 'パスワードを変更する'
      end

      it 'フォームが空欄だとエラーになること' do
        fill_in '新しいパスワード', with: ''
        fill_in '確認用パスワード', with: ''
        click_on 'パスワードを更新する'
        expect(page).to have_content 'パスワードを入力してください'
      end

      it 'パスワードが空欄だとエラーになること' do
        fill_in '新しいパスワード', with: ''
        fill_in '確認用パスワード', with: '123456'
        click_on 'パスワードを更新する'
        expect(page).to have_content 'パスワードを入力してください'
      end

      it 'パスワードが6文字未満だとエラーになること' do
        fill_in '新しいパスワード', with: '12345'
        fill_in '確認用パスワード', with: '12345'
        click_on 'パスワードを更新する'
        expect(page).to have_content 'パスワードは6文字以上に設定して下さい。'
      end

      it '確認用パスワードが空欄だとエラーになること' do
        fill_in '新しいパスワード', with: '123456'
        fill_in '確認用パスワード', with: ''
        click_on 'パスワードを更新する'
        expect(page).to have_content '確認用パスワードが内容とあっていません。'
      end

      it '確認用パスワードが新しいパスワードと一致していないとエラーになること' do
        fill_in '新しいパスワード', with: '123456'
        fill_in '確認用パスワード', with: '987654'
        click_on 'パスワードを更新する'
        expect(page).to have_content '確認用パスワードが内容とあっていません。'
      end
    end

    context '新規アカウント作成フォームの場合' do
      before do
        visit new_user_registration_path
      end

      it 'ユーザー名が空欄だとエラーになること' do
        fill_in 'ユーザー名', with: ''
        fill_in 'メールアドレス', with: 'test@email.com'
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in 'パスワード(確認用)', with: '123456'
        click_on '登録'
        expect(page).to have_content 'ユーザー名を入力してください'
      end

      it 'メールアドレスが空欄だとエラーになること' do
        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in 'パスワード(確認用)', with: '123456'
        click_on '登録'
        expect(page).to have_content 'メールアドレスを入力してください'
      end

      it 'パスワードが空欄だとエラーになること' do
        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'メールアドレス', with: 'test@email.com'
        fill_in 'パスワード(6文字以上)', with: ''
        fill_in 'パスワード(確認用)', with: '123456'
        click_on '登録'
        expect(page).to have_content 'パスワードを入力してください'
        expect(page).to have_content '確認用パスワードが内容とあっていません。'
      end

      it '確認用パスワードが空欄だとエラーになること' do
        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'メールアドレス', with: 'test@email.com'
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in 'パスワード(確認用)', with: ''
        click_on '登録'
        expect(page).to have_content '確認用パスワードが内容とあっていません。'
      end

      it 'パスワードと確認用パスワードの内容が一致していないとエラーになること' do
        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'メールアドレス', with: 'test@email.com'
        fill_in 'パスワード(6文字以上)', with: '123456789'
        fill_in 'パスワード(確認用)', with: '123456'
        click_on '登録'
        expect(page).to have_content '確認用パスワードが内容とあっていません。'
      end

      it 'すでに使用されているメールアドレスを入れるとエラーになること' do
        user
        visit new_user_registration_path
        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード(6文字以上)', with: '123456'
        fill_in 'パスワード(確認用)', with: '123456'
        click_on '登録'
        expect(page).to have_content 'メールアドレスは既に使用されています。'
      end

      it 'パスワードが6文字未満だとエラーになること' do
        fill_in 'ユーザー名', with: 'testuser'
        fill_in 'メールアドレス', with: 'test@email.com'
        fill_in 'パスワード(6文字以上)', with: '12345'
        fill_in 'パスワード(確認用)', with: '12345'
        click_on '登録'
        expect(page).to have_content 'パスワードは6文字以上に設定して下さい。'
      end
    end

    context 'プロフィールの編集フォームの場合' do
      before do
        login_as user
        visit edit_user_registration_path
      end

      it 'ユーザー名が空欄だとエラーになること' do
        find('.username').set('')
        click_on '更新'
        expect(page).to have_content 'ユーザー名を入力してください'
      end

      it 'メールアドレスが空欄だとエラーになること' do
        find('.email').set('')
        click_on '更新'
        expect(page).to have_content 'メールアドレスを入力してください'
      end

      it 'すでに使用されているメールアドレスを設定するとエラーになること', js: true do
        create(:user, email: 'email@email.com')
        visit edit_user_registration_path
        fill_in 'メールアドレス', with: 'email@email.com'
        click_on '更新'
        expect(page).to have_content 'メールアドレスは既に使用されています。'
      end
    end

    context 'プロフィールの編集フォームの場合(ゲストユーザーでログイン時)' do
      before do
        visit new_user_session_path
        find('.guestLogin').click
        visit edit_user_registration_path
      end

      it 'ユーザー名を変更するとエラーになること', js: true do
        fill_in 'ユーザー名', with: 'ゲストです'
        click_on '更新'
        expect(page).to have_content 'ゲストユーザーは変更・削除できません。'
        expect(page).to have_current_path(root_path)
      end

      it 'メールアドレスを変更するとエラーになること', js: true do
        fill_in 'メールアドレス', with: 'user@email.com'
        click_on '更新'
        expect(page).to have_content 'ゲストユーザーは変更・削除できません。'
        expect(page).to have_current_path(root_path)
      end

      it 'アイコンを変更するとエラーになること', js: true do
        attach_file('プロフィールアイコン', Rails.root.join('spec/fixtures/test2.jpg'))
        click_on '更新'
        expect(page).to have_content 'ゲストユーザーは変更・削除できません。'
        expect(page).to have_current_path(root_path)
      end

      it 'アカウントを削除するとエラーになること', js: true do
        click_button '退会したい方はクリック'
        alert = page.driver.browser.switch_to.alert
        alert_text = alert.text
        expect(alert_text).to eq '本当に削除してよろしいですか？'
        alert.accept
        expect(page).to have_content 'ゲストユーザーは変更・削除できません。'
        expect(page).to have_current_path(root_path)
      end
    end
  end
end
