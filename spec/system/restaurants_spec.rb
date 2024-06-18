require 'rails_helper'

RSpec.describe "Restaurants", type: :system do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:restaurant) { create(:restaurant, user: user, country: country) }
  let!(:report) { create(:report, restaurant: restaurant, user: user) }
  let(:country) { create(:country, name: 'ブラジル') }

  describe 'restaurants#indexについてのテスト' do
    before do
      restaurant
      visit restaurants_path
    end

    it '「お店を探す」を押すとcollapseが開くこと' do
      click_button 'お店を探す'
      expect(page).to have_content 'キーワードで検索(店名または住所)'
      expect(page).to have_content 'ランダムで探す'
      expect(page).to have_content '現在地周辺のお店を探す'
      expect(page).to have_content '国から探す'
    end

    it '検索ボタンを押すと検索結果画面に遷移すること' do
      click_button 'お店を探す'
      click_button '検索'
      expect(page).to have_content '登録されているお店'
      expect(page).to have_content '検索結果'
    end

    it '「ランダムで探す」を押すとrestaurant/showのページに遷移すること' do
      click_button 'お店を探す'
      click_on 'ランダムで探す'
      expect(page).to have_current_path(restaurant_path(id: restaurant.id))
    end

    it '「現在地周辺のお店を探す」を押すとsearch_restaurant_by_gpsに遷移すること' do
      click_button 'お店を探す'
      click_on '現在地周辺のお店を探す'
      expect(page).to have_current_path(search_restaurant_by_gps_restaurants_path)
    end

    it '「国から探す」を押すとsearch_restaurant_by_mapに遷移すること' do
      click_button 'お店を探す'
      click_on '国から探す'
      expect(page).to have_current_path(search_restaurant_by_map_restaurants_path)
    end

    it '登録されているrestaurantが表示されていること' do
      expect(page).to have_selector('.restaurant-img')
      expect(page).to have_content(restaurant.name)
      expect(page).to have_content(restaurant.address)
      expect(page).to have_content(restaurant.country.name)
    end

    it '登録されているrestaurantの詳細ボタンを押すと対象のrestaurantのshowページに遷移すること' do
      first('.restaurant-box').click_on '詳細'
      expect(page).to have_current_path(restaurant_path(id: restaurant.id))
    end

    it 'ログインをしないとrestaurantの新規作成ができないこと' do
      click_on 'お店を投稿する'
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
    end

    it 'ログイン後「新しくお店を登録する」を押すとnew_restaurantに遷移すること' do
      login_as user
      visit restaurants_path
      click_on '新しくお店を登録する'
      expect(page).to have_current_path(new_restaurant_path)
    end
  end

  describe 'restaurants#showのログアウト時についてのテスト' do
    before do
      visit restaurant_path(id: restaurant.id)
    end

    it 'ページ内にreportが表示されていないこと' do
      expect(page).not_to have_selector('.report')
    end

    it 'ログインボタンを押すとログインページに遷移すること' do
      click_on '今すぐログインする'
      expect(page).to have_current_path(new_user_session_path)
    end
  end

  describe 'restaurants#search_restaurant_by_keywordsについてのテスト' do
    before do
      create(:restaurant, name: 'マクドナルド', address: '神奈川県')
      create(:restaurant, name: 'バーガーキング', address: '神奈川県')
      create(:restaurant, name: 'モスバーガー', address: '埼玉県')
      visit restaurants_path
      click_button 'お店を探す'
    end

    it 'キーワードを入力すると店名にその単語を全て含むお店がヒットすること' do
      fill_in 'q_name_or_address_cont', with: 'マクドナルド'
      click_on '検索'
      expect(page).to have_content 'マクドナルドの検索結果'
      expect(page).to have_selector '.restaurant-name', text: 'マクドナルド'
      expect(page).to have_content '全1件'
    end

    it 'キーワードを入力すると住所にその単語を全て含むお店がヒットすること' do
      fill_in 'q_name_or_address_cont', with: '神奈川県'
      click_on '検索'
      expect(page).to have_content '神奈川県の検索結果'
      expect(page).to have_content 'マクドナルド'
      expect(page).to have_content 'バーガーキング'
      expect(page).not_to have_content 'モスバーガー'
      expect(page).to have_content '全2件'
    end

    it '検索ワードに店名と住所を入力してAND検索ができること' do
      fill_in 'q_name_or_address_cont', with: '神奈川県 マクドナルド'
      click_on '検索'
      expect(page).to have_content '神奈川県 マクドナルドの検索結果'
      expect(page).to have_content 'マクドナルド'
      expect(page).not_to have_content 'バーガーキング'
      expect(page).not_to have_content 'モスバーガー'
      expect(page).to have_content '全1件'
    end
  end

  describe 'restaurants#search_restaurant_by_gpsについてのテスト' do
    it '一つ前に戻るボタンで前に開いていたページに遷移できること' do
      visit restaurants_path
      click_button 'お店を探す'
      click_on '現在地周辺のお店を探す'
      click_on '一つ前に戻る'
      expect(page).to have_current_path(restaurants_path)
    end

    before do
      visit search_restaurant_by_gps_restaurants_path
      sleep 4
    end

    it 'google mapが表示されていること', js: true do
      expect(page).to have_selector('.gmnoprint')
    end

    it 'google mapの中に自分の現在地にピンが立っていること', js: true do
      expect(page).to have_selector('#gmimap0')
    end

    it '登録されているお店のピンが表示されていること', js: true do
      5.times do
        find('button[aria-label="ズームアウト"]').click
      end
      expect(page).to have_selector('div[role="button"]')
    end

    it '登録しているお店のピンを押して詳細ページに遷移できること', js: true do
      5.times do
        find('button[aria-label="ズームアウト"]').click
      end
      find('div[role="button"]').click
      expect(page).to have_selector('.gm-style-iw')
      find('.gm-style-iw-d').click
      expect(page).to have_current_path(restaurant_path(id: restaurant.id))
    end
  end

  describe 'restaurants#search_restaurant_by_mapについてのテスト' do
    it '一つ前に戻るボタンで前に開いていたページに遷移できること' do
      visit restaurants_path
      click_button 'お店を探す'
      click_on '国から探す'
      click_on '一つ前に戻る'
      expect(page).to have_current_path(restaurants_path)
    end

    it 'ページにgoogle my mapが表示されていること' do
      visit search_restaurant_by_map_restaurants_path
      sleep 4
      expect(page).to have_selector('#worldMap')
    end

    it '国ごとの検索結果のページが正しく表示されること' do
      create(:restaurant)
      visit search_restaurant_by_map_results_restaurant_path(id: country.id)
      expect(page).to have_content 'ブラジルの検索結果'
      expect(page).to have_content '全1件'
      expect(page).to have_content(restaurant.name)
      expect(page).to have_content(restaurant.address)
      expect(page).to have_content(restaurant.country.name)
      expect(page).to have_content '詳細'
    end
  end

  describe 'CRUD処理についてのテスト' do
    before do
      login_as user
      visit restaurants_path
      click_on '新しくお店を登録する'
    end

    it 'restaurantを新規作成できること', js: true do
      fill_in 'お店の名前', with: 'Churrascaria Que bom!'
      fill_in '郵便番号(ハイフンなし)', with: '1110035'
      sleep 1
      existing_address = find('#restaurant_address').value
      new_address = existing_address + '2丁目15番地13-B1'
      fill_in '住所', with: new_address
      fill_in 'どこの国の料理が食べられる？(入力すると下に候補が出ます)', with: 'ブラジル'
      find('.child').click
      attach_file('写真', Rails.root.join('spec/fixtures/test2.jpg'))
      fill_in 'メモ・感想', with: '食べ放題では店員さんが焼きたてのシュラスコを持ってきてくださいます！焼きパインがシナモン効いてて大好きです'
      click_on '登録'
      restaurant = Restaurant.last
      expect(page).to have_current_path(restaurant_path(id: restaurant.id))
      expect(page).to have_content 'お店の登録に成功しました。投稿ありがとう！'
      expect(page).to have_content 'Churrascaria Que bom!'
      expect(page).to have_content '〒1110035'
      expect(page).to have_content '東京都台東区西浅草2丁目15番地13-B1'
      expect(page).to have_content 'ブラジル料理店'
      expect(page).to have_content '食べ放題では店員さんが焼きたてのシュラスコを持ってきてくださいます！焼きパインがシナモン効いてて大好きです'
      expect(page).to have_selector("img[src*='test2.jpg']")
    end

    it '新規作成時に写真を無しにするとデフォルトの画像が入ること', js: true do
      fill_in 'お店の名前', with: 'Churrascaria Que bom!'
      fill_in '郵便番号(ハイフンなし)', with: '1110035'
      existing_address = find_field('住所').value
      new_address = existing_address + '2丁目15番地13-B1'
      fill_in '住所', with: new_address
      fill_in 'どこの国の料理が食べられる？(入力すると下に候補が出ます)', with: 'ブラジル'
      find('.child').click
      fill_in 'メモ・感想', with: '食べ放題では店員さんが焼きたてのシュラスコを持ってきてくださいます！焼きパインがシナモン効いてて大好きです'
      click_on '登録'
      expect(page).to have_selector("img[src*='noimage.png']")
    end

    it '写真を選択した時にプレビューが表示されること', js: true do
      attach_file('写真', Rails.root.join('spec/fixtures/test2.jpg'))
      expect(page).to have_selector 'img.preview-img'
    end

    it '郵便番号を入れると自動で住所が入力されること', js: true do
      fill_in '郵便番号', with: '1000000'
      expect(page).to have_field '住所', with: '東京都千代田区'
    end

    it '国名のフォームに文字を入力すると候補が出現すること', js: true do
      fill_in 'どこの国の料理が食べられる？(入力すると下に候補が出ます)', with: 'ブラジル'
      expect(page).to have_selector '.child', text: 'ブラジル'
    end

    it '国名の候補をクリックするとidが入力されること', js: true do
      fill_in 'どこの国の料理が食べられる？(入力すると下に候補が出ます)', with: 'ブラジル'
      find('.child').click
      expect(find('#restaurant_country_id', visible: false).value).to eq country.id.to_s
    end

    it '「一覧に戻る」でrestaurants#indexに遷移すること' do
      click_on '一覧に戻る'
      expect(page).to have_current_path(restaurants_path)
    end

    it 'restaurantの詳細を表示できること', js: true do
      visit restaurants_path
      click_on '詳細'
      expect(page).to have_current_path(restaurant_path(id: restaurant.id))
      expect(page).to have_content '一つ前に戻る'
      expect(page).to have_selector "img[src*='test.jpg']"
      expect(page).to have_content(restaurant.name)
      expect(page).to have_content(restaurant.postal_code)
      expect(page).to have_content(restaurant.address)
      expect(page).to have_content(restaurant.country.name)
      expect(page).to have_content(restaurant.memo)
      expect(page).to have_selector('.gm-style')
    end

    context 'ログインしているユーザーがrestaurantを作成したユーザーと同じ場合' do
      before do
        login_as user
        visit restaurant_path(id: restaurant.id)
      end

      it 'restaurantの編集と削除ボタンが出現すること' do
        expect(page).to have_selector '.restaurant-edit', text: '編集'
        expect(page).to have_selector '.restaurant-delete', text: '削除'
      end

      it 'restaurantの編集ができること' do
        expect(page).to have_selector 'h1.display-5', text: restaurant.name
        find('.restaurant-edit').click
        fill_in 'お店の名前', with: 'Churrascaria Que bom!'
        click_on '登録'
        expect(page).to have_content 'お店の情報を更新しました。'
        expect(page).to have_current_path(restaurant_path(id: restaurant.id))
        expect(page).to have_selector 'h1.display-5', text: 'Churrascaria Que bom!'
      end

      it 'restaurantの削除ができること' do
        create(:restaurant, user: user)
        visit restaurants_path
        expect(page).to have_selector('.restaurant-box', count: 2)
        first('.restaurant-box').click_on '詳細'
        find('.restaurant-delete').click
        expect(page).to have_current_path(restaurants_path)
        expect(page).to have_content 'お店を削除しました。'
        expect(page).to have_selector('.restaurant-box', count: 1)
      end
    end

    context 'ログインしているユーザーがrestaurantを作成したユーザーと異なる場合' do
      it 'restaurantの編集と削除ボタンが出現しないこと' do
        login_as user2
        visit restaurant_path(id: restaurant.id)
        expect(page).not_to have_selector '.restaurant-edit', text: '編集'
        expect(page).not_to have_selector '.restaurant-delete', text: '削除'
      end
    end
  end

  describe 'フォームのバリデーションについてのテスト' do
    before do
      login_as user
      create(:country)
      visit new_restaurant_path
    end

    it 'お店の名前が空欄だとエラーになること', js: true do
      fill_in 'お店の名前', with: ''
      fill_in '郵便番号(ハイフンなし)', with: '1110035'
      existing_address = find_field('住所').value
      new_address = existing_address + '2丁目15番地13-B1'
      fill_in '住所', with: new_address
      fill_in 'どこの国の料理が食べられる？(入力すると下に候補が出ます)', with: 'ブラジル'
      find('.child').click
      click_on '登録'
      expect(page).to have_content 'お店の名前を入力してください'
    end

    it '郵便番号が空欄だとエラーになること', js: true do
      fill_in 'お店の名前', with: 'Churrascaria Que bom!'
      fill_in '郵便番号(ハイフンなし)', with: ''
      existing_address = find_field('住所').value
      new_address = existing_address + '2丁目15番地13-B1'
      fill_in '住所', with: new_address
      fill_in 'どこの国の料理が食べられる？(入力すると下に候補が出ます)', with: 'ブラジル'
      find('.child').click
      click_on '登録'
      expect(page).to have_content '郵便番号を入力してください'
    end

    it '住所が空欄だとエラーになること', js: true do
      fill_in 'お店の名前', with: 'Churrascaria Que bom!'
      fill_in '郵便番号(ハイフンなし)', with: '1110035'
      fill_in 'どこの国の料理が食べられる？(入力すると下に候補が出ます)', with: 'ブラジル'
      find('.child').click
      page.execute_script("document.getElementById('restaurant_address').value = ''")
      click_on '登録'
      expect(page).to have_content '住所を入力してください'
    end

    it '国名が空欄だとエラーになること', js: true do
      fill_in 'お店の名前', with: 'Churrascaria Que bom!'
      fill_in '郵便番号(ハイフンなし)', with: '1110035'
      existing_address = find_field('住所').value
      new_address = existing_address + '2丁目15番地13-B1'
      fill_in '住所', with: new_address
      fill_in 'どこの国の料理が食べられる？(入力すると下に候補が出ます)', with: ''
      click_on '登録'
      expect(page).to have_content '国を入力してください'
    end

    it '国名を候補からクリックせず入力するだけだとエラーになること', js: true do
      fill_in 'お店の名前', with: 'Churrascaria Que bom!'
      fill_in '郵便番号(ハイフンなし)', with: '1110035'
      existing_address = find_field('住所').value
      new_address = existing_address + '2丁目15番地13-B1'
      fill_in '住所', with: new_address
      fill_in 'どこの国の料理が食べられる？(入力すると下に候補が出ます)', with: 'ブラジル'
      click_on '登録'
      expect(page).to have_content '国を入力してください'
    end

    it '新規作成時にバリデーションを発生させてから別のページに行くとメッセージが表示されること' do
      click_on '登録'
      click_on 'お店を探す'
      expect(page).to have_content 'お店の登録に失敗しました。'
    end

    it '編集時にバリデーションを発生させてから別のページに行くとメッセージが表示されること', js: true do
      visit edit_restaurant_path(id: restaurant.id)
      fill_in 'お店の名前', with: ''
      click_on '登録'
      click_on 'お店を探す'
      expect(page).to have_content 'お店の情報更新に失敗しました。'
    end

    it 'お店の削除中に何かエラーが起きた場合はメッセージが表示されること' do
      allow_any_instance_of(Restaurant).to receive(:destroy).and_return(false)
      visit restaurant_path(id: restaurant.id)
      find('.restaurant-delete').click
      expect(page).to have_content 'お店を削除できませんでした。'
    end
  end
end
