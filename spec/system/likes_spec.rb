require 'rails_helper'

RSpec.describe "Likes", type: :system do
let(:restaurant) { create(:restaurant) }
let(:user) { create(:user) }

before do
  login_as user
  visit restaurant_path(id: restaurant.id)
end

  it 'いいねが無効の状態からrestaurantのハートを押すといいねが有効になること', js: true do
    expect(page).to have_selector('.like-button .unlike')
    expect{
      find('.like-button').click
      expect(page).to have_selector('.like-button .like')
    }.to change { Like.count }.by(1)
    expect(user.likes.exists?(restaurant_id: restaurant.id)).to be_truthy
  end
  
  it 'いいねが有効の状態でもう一度ハートを押すといいねが無効になること', js: true do
    find('.like-button').click
    expect(page).to have_selector('.like-button .like')
    expect {
      find('.like-button').click
      expect(page).to have_selector('.like-button .unlike')
    }.to change { Like.count }.by(-1)
    expect(user.likes.exists?(restaurant_id: restaurant.id)).to be_falsey
  end

  it '押したいいねはuserのいいねしたお店一覧に表示されること', js: true do
    find('.like-button').click
    find('#navbarDropdown').click
    click_on 'いいねしたお店'
    expect(page).to have_link 'テストのお店1'
  end

  it 'いいねを無効にするとuserのいいねしたお店一覧から削除されること', js: true do
    find('.like-button').click
    find('#navbarDropdown').click
    click_on 'いいねしたお店'
    click_on 'テストのお店1'
    find('.like-button').click
    expect(page).to have_selector('.like-button .unlike')
    find('#navbarDropdown').click
    click_on 'いいねしたお店'
    expect(page).not_to have_link 'テストのお店1'
  end

  it 'ログインをしていないといいねのボタンが表示されないこと' do
    expect(page).to have_selector('.like-button .unlike')
    find('#navbarDropdown').click
    click_on 'ログアウト'
    click_on 'お店を探す'
    click_on '詳細'
    expect(page).not_to have_selector('.like-button .unlike')
  end
end
