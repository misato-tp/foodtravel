require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) { create(:country) }

  it "名前があれば有効な状態であること" do
    expect(country).to be_valid
  end
end
