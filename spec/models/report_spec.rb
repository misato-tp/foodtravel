require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:report) { create(:report) }
  let(:user) { create(:user) }
  let(:restaurant) { create(:restaurant) }

  describe 'reportのバリデーションに関するテスト' do
    context '投稿可能な場合' do
      it 'title, memoが最低限入力されていれば有効であること' do
        report = build(:report, image: nil, recommend: nil)
        expect(report).to be_valid
      end
    end

    context '投稿不可能な場合' do
      it 'titleがない場合は無効であること' do
        report = build(:report, title: nil)
        report.valid?
        expect(report.errors[:title]).to include('を入力してください')
      end

      it 'memoがない場合は無効であること' do
        report = build(:report, memo: nil)
        report.valid?
        expect(report.errors[:memo]).to include('を入力してください')
      end

      it 'userなしのreport投稿は無効であること' do
        report = build(:report, user: nil)
        report.valid?
        expect(report.errors[:user]).to include('を入力してください')
      end

      it 'restaurantなしのreport投稿は無効であること' do
        report = build(:report, restaurant: nil)
        report.valid?
        expect(report.errors[:restaurant]).to include('を入力してください')
      end
    end
  end
end
