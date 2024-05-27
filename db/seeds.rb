countries = [ '韓国', '中国','モンゴル', 'インドネシア', 'ブルネイ', 'カンボジア', 'ベトナム', 'シンガポール', 'マレーシア', 'タイ', 'ミャンマー', '東ティモール', 'ラオス', 'フィリピン', 
              'インド', 'スリランカ', 'ネパール', 'パキスタン', 'バングラデシュ', 'ブータン', 'モルディブ',
              'アフガニスタン', 'サウジアラビア', 'アラブ首長国連邦', 'シリア', 'イエメン', 'トルコ', 'イスラエル', 'バーレーン',
              'イラク', 'ヨルダン', 'イラン', 'レバノン', 'オマーン', 'カタール', 'クウェート',
              'アイスランド', 'スウェーデン', 'ブルガリア', 'アイルランド', 'スペイン', 'ベルギー', 'アルバニア', 'スロバキア', 'ポーランド', 'アンドラ',
              'スロベニア', 'ボスニア・ヘルツェゴビナ', 'イタリア', 'セルビア', 'ポルトガル', 'イギリス(北アイルランドを含む)', 'チェコ', 'マケドニア', 'オーストリア', 'デンマーク',
              'マルタ', 'オランダ', 'ドイツ', 'モナコ', 'キプロス', 'ノルウェー', 'モンテネグロ', 'ギリシャ', 'バチカン', 'リヒテンシュタイン', 'クロアチア',
              'ハンガリー', 'ルーマニア', 'サンマリノ', 'フィンランド', 'ルクセンブルグ', 'スイス', 'フランス', 'エストニア', 'ラトビア', 'リトアニア',
              'アルジェリア','モロッコ','エジプト','リビア','チュニジア',
              'アンゴラ', 'サントメ・プリンシペ', 'ナミビア', 'ウガンダ', 'ザンビア', 'ニジェール', 'エチオピア', 'シエラレオネ',
              'ブルキナファソ', 'エリトリア', 'ジブチ', 'ブルンジ', 'ガーナ', 'ジンバブエ', 'ベナン', 'カーボヴェルデ', 'スーダン', 'ボツワナ',
              'ガボン', 'エスワティニ', 'マダガスカル', 'カメルーン', 'セーシェル', 'マラウイ', 'ガンビア', '赤道ギニア', 'マリ', 'ギニア',
              'セネガル', '南アフリカ', 'ギニアビサウ', 'ソマリア', 'モザンビーク', 'ケニア', 'タンザニア', 'モーリシャス', 'コートジボワール',
              'チャド', 'モーリタニア', 'コモロ', '中央アフリカ共和国', 'リベリア', 'コンゴ共和国', 'トーゴ', 'ルワンダ', 'コンゴ民主共和国', 'ナイジェリア', 'レソト',
              'アゼルバイジャン', 'アルメニア', 'ウクライナ', 'ウズベキスタン', 'カザフスタン', 'キルギス', 'ジョージア(グルジア)', 'タジキスタン', 'トルクメニスタン',
              'ベラルーシ', 'モルドバ', 'ロシア',
              'オーストラリア', 'キリバス', 'サモア', 'ソロモン諸島', 'ツバル', 'トンガ', 'ナウル', 'ニュージーランド', 'バヌアツ', 'パプアニューギニア',
              'パラオ', 'フィジー', 'マーシャル諸島', 'ミクロネシア',
              'アメリカ', 'カナダ',
              'アルゼンチン', 'ドミニカ国', 'アンティグア・バーブーダ', 'ドミニカ共和国', 'ウルグアイ', 'トリニダード・トバゴ', 'エクアドル', 'ニカラグア',
              'エルサルバドル', 'ハイチ', 'ガイアナ', 'パナマ', 'キューバ', 'バハマ', 'グアテマラ', 'パラグアイ', 'グレナダ', 'バルバドス', 'コスタリカ',
              'ブラジル', 'コロンビア', 'ベネズエラ', 'ジャマイカ', 'ベリーズ', 'スリナム', 'ペルー', 'セントビンセントおよびグレナディーン諸島', 'ボリビア',
              'セントクリストファー・ネーヴィス', 'ホンジュラス', 'セントルシア', 'メキシコ', 'チリ', '南スーダン'
            ]
countries.each do |country_name|
  Country.create(name: country_name)
end

bucket_name = ENV['AWS_BUCKET_NAME']
region = ENV['AWS_REGION']
base_url = "https://#{bucket_name}.s3.#{region}.amazonaws.com"

seed_user = User.create!(
  username: "匿名",
  email: "tokumei@example.com",
  password: ENV['TOKUMEI_PASSWORD'],
  password_confirmation: ENV['TOKUMEI_PASSWORD']
)

Restaurant.create!([
  { 
    name: "WORLD BREAKFAST ALLDAY",
    postal_code: 1500001,
    address: "東京都渋谷区神宮前3-1-23",
    user_id: seed_user.id,
    country_id: 52,
    remote_image_url: "#{base_url}/app-images/WORLD-BREAKFAST-ALLDAY.JPG",
    memo: "美味しい世界の朝ごはんが食べられます。"
  },
  { 
    name: "カンガンスルレ",
    postal_code: 1070052,
    address: "東京都港区赤坂3-15-12",
    user_id: seed_user.id,
    country_id: 1,
    remote_image_url: "#{base_url}/app-images/kangansurure.jpeg",
    memo: "韓国料理が美味しいです。"
  },
  {
    name: "志摩スペイン村 ヒラソル",
    postal_code: 5170292,
    address: "三重県志摩市磯部町坂崎",
    user_id: seed_user.id,
    country_id: 41,
    remote_image_url: "#{base_url}/app-images/spainmura.JPG",
    memo: "内装もおしゃれで、コース料理も楽しめます。"
  },
  {
    name: "ALDO 麻布台ヒルズ店",
    postal_code: 1060041,
    address: "東京都港区麻布台1-6-19",
    user_id: seed_user.id,
    country_id: 184,
    remote_image_url: "#{base_url}/app-images/aldo-food1.jpeg",
    memo: "日本で南米の味が楽しめます。"
  },
  {
    name: "シンガポール海南鶏飯 水道橋本店",
    postal_code: 1010061,
    address: "東京都千代田区神田三崎町2-1-1",
    user_id: seed_user.id,
    country_id: 8,
    remote_image_url: "#{base_url}/app-images/kainan.jpeg",
    memo: "伝統的なシンガポール料理を楽しめます。"
  }
])

Report.create!([
  {
    title: "イギリスの朝食",
    remote_image_url: "#{base_url}/app-images/WORLD-BREAKFAST-ALLDAY-food.JPG",
    recommend: "English breakfast",
    memo: "イギリスの定番朝ごはん「フルブレックファスト」をいただきました。おいしかったです！",
    user_id: seed_user.id,
    restaurant_id: Restaurant.first.id
  },
  {
    title: "ボリューミーで◎",
    remote_image_url: "#{base_url}/app-images/kangansurure-food.jpeg",
    memo: "韓国料理が気軽に楽しめます。",
    user_id: seed_user.id,
    restaurant_id: Restaurant.second.id
  },
  {
    title: "見た目も楽しい料理",
    remote_image_url: "#{base_url}/app-images/spainmura-food.jpeg",
    recommend: "パエリア",
    memo: "素敵なパエリアをいただきました。魚介の旨みが詰まっています！",
    user_id: seed_user.id,
    restaurant_id: Restaurant.third.id
  },
  {
    title: "コースに満足です",
    remote_image_url: "#{base_url}/app-images/spainmura-food2.JPG",
    memo: "どのお料理も満足でした",
    user_id: seed_user.id,
    restaurant_id: Restaurant.third.id
  },
  {
    title: "ゆっくり楽しめました",
    remote_image_url: "#{base_url}/app-images/spainmura-food3.jpg",
    memo: "お店の雰囲気もよく、お酒と料理を楽しめます",
    user_id: seed_user.id,
    restaurant_id: Restaurant.third.id
  },
  {
    title: "初ペルー料理",
    remote_image_url: "#{base_url}/app-images/aldo-food2.JPG",
    memo: "初めてペルー料理をいただきましたが、思ったよりクセがなく美味しいものばかりです！",
    user_id: seed_user.id,
    restaurant_id: Restaurant.fourth.id
  },
  {
    title: "香りがいい！",
    remote_image_url: "#{base_url}/app-images/kainan-food.JPG",
    recommend: "シンガポールチキンライス",
    memo: "特にソース、ライスの香りがとてもよかったです。",
    user_id: seed_user.id,
    restaurant_id: Restaurant.fifth.id
  }
])
