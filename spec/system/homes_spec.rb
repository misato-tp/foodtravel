require 'rails_helper'

RSpec.describe "Countries", type: :system do
  let(:user) { create(:user) }
  let(:restaurant) { create(:restaurant) }

  before do
    visit root_path
  end

  it '正常にhome#indexが表示されていること' do
    expect(page).to have_http_status(:success)
  end

  describe 'ヘッダーに関するテスト' do
    context 'ログインの有無に関わらない部分の場合' do
      it 'サイトのアイコンを押すとrootに遷移すること' do
        find('.navbar-brand')
        expect(page).to have_current_path(root_path)
      end

      it '「お店を探す」を押すとrestaurants#indexに遷移すること' do
        restaurant
        click_on 'お店を探す'
        expect(page).to have_current_path(restaurants_path)
      end
    end

    context 'ログアウトしている時' do
      it '「お店を投稿する」を押すとログイン画面に遷移すること' do
        click_on 'お店を投稿する'
        expect(page).to have_content 'アカウント登録もしくはログインしてください。'
        expect(page).to have_current_path(new_user_session_path)
      end

      it '「ログイン」を押すとログイン画面に遷移すること' do
        click_on 'ログイン'
        expect(page).to have_current_path(new_user_session_path)
      end

      it '「新規登録」を押すとユーザー新規登録画面に遷移すること' do
        click_on '新規登録'
        expect(page).to have_current_path(new_user_registration_path)
      end
    end

    context 'ログインしている時' do
      before do
        login_as user
        visit root_path
      end

      it '「お店を投稿する」を押すとrestaurants#newに遷移すること' do
        click_on 'お店を投稿する'
        expect(page).to have_current_path(new_restaurant_path)
      end

      it '「マイページ」を押すとドロップダウンリストが出現すること' do
        find('.nav-item.dropdown').click
        expect(page).to have_selector('.dropdown-menu')
      end

      it 'ドロップダウンリストの「いいねしたお店」を押すとそのページに遷移すること' do
        find('.nav-item.dropdown').click
        click_on 'いいねしたお店'
        expect(page).to have_current_path(likes_user_path(id: user.id))
      end

      it 'ドロップダウンリストの「投稿したお店」を押すとそのページに遷移すること' do
        find('.nav-item.dropdown').click
        click_on '投稿したお店'
        expect(page).to have_current_path(myrestaurants_users_path)
      end

      it 'ドロップダウンリストの「投稿したレポ」を押すとそのページに遷移すること' do
        find('.nav-item.dropdown').click
        click_on '投稿したレポ'
        expect(page).to have_current_path(myreports_users_path)
      end

      it 'ドロップダウンリストの「プロフィール」を押すとそのページに遷移すること' do
        find('.nav-item.dropdown').click
        click_on 'プロフィール'
        expect(page).to have_current_path(profile_users_path)
      end

      it 'ドロップダウンリストの「ログアウト」を押すとログアウトされること' do
        find('.nav-item.dropdown').click
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました。'
        expect(page).to have_current_path(root_path)
      end
    end
  end

  describe 'ルートページ関するテスト' do
    it 'カルーセルの画像が全部で3枚時間差で切り替わり表示されること', js: true do
      expect(page).to have_selector('.carousel-item.active img[src*="paeria.jpg"]')
      sleep 4
      expect(page).to have_selector('.carousel-item.active img[src*="pizza.jpg"]')
      sleep 4
      expect(page).to have_selector('.carousel-item.active img[src*="yakitori.jpg"]')
    end

    it '「国から探す」を押すとrestaurants#search_restaurant_by_mapに遷移すること', js: true do
      click_on '国から探す'
      expect(page).to have_current_path(search_restaurant_by_map_restaurants_path)
    end

    it '「現在地から探す」を押すとrestaurants#search_restaurant_by_gpsに遷移すること', js: true do
      click_on '現在地から探す'
      expect(page).to have_current_path(search_restaurant_by_gps_restaurants_path)
    end

    it 'ログインをした状態で「みんなに紹介する」を押すとrestaurants#newに遷移すること' do
      login_as user
      click_on 'みんなに紹介する'
      expect(page).to have_current_path(new_restaurant_path)
    end

    it 'ログアウトしている状態で「みんなに紹介する」を押すとログインページに遷移すること' do
      click_on 'みんなに紹介する'
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
      expect(page).to have_current_path(new_user_session_path)
    end

    it '「行ったお店を探す」を押すとrestaurant#indexに遷移すること' do
      restaurant
      click_on '行ったお店を探す'
      expect(page).to have_current_path(restaurants_path)
    end
  end
end