require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) { build(:country) }

  it "国名が空の場合無効であること" do
    country.name = ""
    country.valid?
    expect(country.errors[:name]).to include("が入力されていません。")
  end
end
