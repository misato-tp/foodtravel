require 'rails_helper'

RSpec.describe "Countries", type: :system do
  let(:user) { create(:user) }
  let!(:country) { create(:country, id: 1) }
  let!(:restaurant) { create(:restaurant, country: country) }

  it 'レストランを作成時に国を選択するとidがhidden項目に反映されること', js: true do
    login_as user
    visit new_restaurant_path
    fill_in 'どこの国の料理が食べられる？(入力すると下に候補が出ます)', with: '韓国'
    expect(page).to have_selector('#search-result', text: '韓国', visible: true)
    find('#search-result .child', text: '韓国').click
    expect(find('#restaurant_country_id', visible: false).value).to eq '1'
  end

  it 'URLに国のidを入れるとその国が選択されたレストランの検索結果が表示されること' do
    visit search_restaurant_by_map_results_restaurant_path(id: country.id)
    expect(page).to have_content('韓国の検索結果')
    expect(page).to have_content('全1件')
    expect(page).to have_selector '.restaurant-country', text: '韓国'
  end
end
