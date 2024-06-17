require 'rails_helper'

RSpec.describe "Reports", type: :system do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:restaurant) { create(:restaurant, user: user) }
  let!(:report) { create(:report, restaurant: restaurant, user: user) }

  it 'restaurantのshowページにreportがあれば正しく表示されていること' do
    visit restaurant_path(id: restaurant.id)
    expect(page).to have_content(report.title)
    expect(page).to have_css('.report-image')
    expect(page).to have_content(report.recommend)
    expect(page).to have_content(report.memo)
    expect(page).to have_css('.user-image')
    expect(page).to have_content(report.user.username)
  end

  context 'ログインをしていない場合' do
    it 'reportの新規作成をしようとするとログイン画面に遷移すること' do
      visit restaurant_path(id: restaurant.id)
      click_on 'このお店のレポを書く'
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content 'アカウント登録もしくはログインしてください。'
    end
  end

  context 'reportを書いたユーザーがログインユーザーと異なる場合' do
    it 'reportの編集と削除が表示されないこと' do
      login_as user2
      visit restaurant_path(id: restaurant.id)
      expect(page).not_to have_selector '.report-edit', text: '編集'
      expect(page).not_to have_selector '.report-delete', text: '削除'
    end
  end

  context 'reportを書いたユーザーがログインユーザーと同じ場合' do
    before do
      login_as user
      visit restaurant_path(id: restaurant.id)
    end

    it '編集と削除のリンクが表示されること' do
      expect(page).to have_selector '.report-edit', text: '編集'
      expect(page).to have_selector '.report-delete', text: '削除'
    end

    it '削除ボタンを押すと投稿を消せること' do
      find('.report-delete').click
      expect(page).to have_current_path(restaurant_path(id: restaurant.id))
      expect(page).to have_content 'レポを削除しました。'
      expect(page).to have_content '投稿されたレポはまだありません。'
    end

    it '編集ボタンを押すと画面が編集画面に遷移すること' do
      find('.report-edit').click
      expect(page).to have_current_path(edit_restaurant_report_path(restaurant_id: restaurant.id, id: report.id))
    end

    it '編集画面のフォームにはもともと入力していたデータが入っていること' do
      find('.report-edit').click
      expect(page).to have_field 'タイトル', with: 'テストレポート1'
      expect(page).to have_field 'おすすめの料理', with: 'おすすめ料理'
      expect(page).to have_field 'メモ', with: 'テストメモ'
      expect(page).to have_selector '.uploaded-image', text: 'test.jpg'
    end

    it '各フォームの内容を変更して反映できること' do
      find('.report-edit').click
      fill_in 'タイトル', with: 'おいしかった'
      fill_in 'おすすめの料理', with: 'オムライス'
      fill_in 'メモ', with: '思い出の味です'
      attach_file('写真', Rails.root.join('spec/fixtures/test2.jpg'))
      click_on '登録'
      expect(page).to have_current_path(restaurant_path(id: restaurant.id))
      expect(page).to have_content 'レポを更新しました。'
      expect(page).to have_selector '.report-title', text: 'おいしかった'
      expect(page).to have_selector '.report-recommend', text: 'オムライス'
      expect(page).to have_selector '.report-memo', text: '思い出の味です'
      expect(page).to have_selector "img[src*='test2.jpg']"
    end

    it 'editのフォームで画像を選択したときにプレビューがでてくること', js: true do
      find('.report-edit').click
      attach_file('写真', Rails.root.join('spec/fixtures/test2.jpg'))
      expect(page).to have_selector 'img.preview-img'
    end

    it 'reportの新規作成を押すとページが正しくフォームに遷移すること' do
      click_on 'このお店のレポを書く'
      expect(page).to have_current_path(new_restaurant_report_path(restaurant_id: restaurant.id))
    end

    it 'reportを新規作成し、登録できること' do
      click_on 'このお店のレポを書く'
      fill_in 'タイトル', with: 'おいしかった'
      fill_in 'おすすめの料理', with: 'オムライス'
      fill_in 'メモ', with: '思い出の味です'
      attach_file('写真', Rails.root.join('spec/fixtures/test2.jpg'))
      click_on '登録'
      expect(page).to have_current_path(restaurant_path(id: restaurant.id))
      expect(page).to have_content 'レポの登録に成功しました。投稿ありがとう！'
      expect(page).to have_selector '.report-title', text: 'おいしかった'
      expect(page).to have_selector '.report-recommend', text: 'オムライス'
      expect(page).to have_selector '.report-memo', text: '思い出の味です'
      expect(page).to have_selector "img[src*='test2.jpg']"
    end

    it 'フォームのtitleが空白だとバリデーションメッセージが出ること' do
      click_on 'このお店のレポを書く'
      fill_in 'おすすめの料理', with: 'オムライス'
      fill_in 'メモ', with: '思い出の味です'
      attach_file('写真', Rails.root.join('spec/fixtures/test2.jpg'))
      click_on '登録'
      expect(page).to have_content 'タイトルを入力してください'
    end

    it 'フォームのmemoが空白だとバリデーションメッセージが出ること' do
      click_on 'このお店のレポを書く'
      fill_in 'タイトル', with: 'おいしかった'
      fill_in 'おすすめの料理', with: 'オムライス'
      attach_file('写真', Rails.root.join('spec/fixtures/test2.jpg'))
      click_on '登録'
      expect(page).to have_content 'メモを入力してください'
    end

    it '一つ前に戻るボタンで前に開いていたページに戻れること' do
      click_on 'このお店のレポを書く'
      click_on '一つ前に戻る'
      expect(page).to have_current_path(restaurant_path(id: restaurant.id))
    end

    it '新規作成でフォームのバリデーションを作動させてから他のページに行くとメッセージが表示されること' do
      click_on 'このお店のレポを書く'
      fill_in 'タイトル', with: 'おいしかった'
      click_on '登録'
      expect(page).to have_content 'メモを入力してください'
      click_on 'お店を探す'
      expect(page).to have_content 'レポの登録に失敗しました。'
    end

    it 'reportの編集でバリデーションを作動させてから他のページに行くとメッセージが表示されること' do
      find('.report-edit').click
      fill_in 'タイトル', with: ''
      click_on '登録'
      expect(page).to have_content 'タイトルを入力してください'
      click_on 'お店を探す'
      expect(page).to have_content 'レポの更新に失敗しました。'
    end
  end
end
