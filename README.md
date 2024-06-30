# FOOD-TRAVEL
<div align="center">
  <img width="200" style="text-center" src="https://github.com/misato-tp/foodtravel/assets/138008284/f1fdd518-d9f6-4d5a-8595-e62fe45f4b66">

「国内で、海外のご飯を楽しみたい！」

「ご飯で海外気分を味わいたい！」　

「みんなにお気に入りのお店を紹介したい！」

そんなときに活躍する、情報共有webサイトです。

レスポンシブにも対応しておりますので、スマートフォンからもご使用いただけます。

<img width="1440" alt="スクリーンショット 2024-06-17 13 40 03" src="https://github.com/misato-tp/foodtravel/assets/138008284/75d3acf7-7ed1-4deb-b194-94703c0921c8">

<img width="314" alt="スクリーンショット 2024-06-19 0 14 09" src="https://github.com/misato-tp/foodtravel/assets/138008284/3ff0edd7-3d65-4b57-aa4f-eeca3313cbbc">

</div>

# ⭐URL
https://foodtravel-5c7b1abd1960.herokuapp.com/ <br>
<p>ゲストログインは ヘッダーの<b>ログイン > ゲストでログイン</b>　から可能です。</p>

# ⭐このアプリを作った背景
コロナが大流行した時に、海外旅行に行きたくても行けないということが起こりました。<br>
私も大学の卒業旅行で韓国に友人と行く予定を立てていましたが、コロナ大流行中で海外旅行はおろか、外出も思うようにできず。<br>
悲しみでいっぱいでしたが、せめて韓国気分を味わうならどうしたらいいか考えた時に、<br>
「韓国料理のお店に行こう！」と考えました。<br>

現地の食材を使っていたり、本場の味に近いという口コミが書かれていたり。<br>
ときたまに飛び交う言語が日本語じゃなかったり。<br>
日本にいるのに、海外にいる気分になれる！<br>
そんな飲食店が日本にはたくさんあることを知り、<br>
ちょっとした気分転換になれる魅力が外国料理にお店にあると感じました。

この体験から、日常の中でも気軽に海外ご飯が食べられるお店専門で調べられるものがあるといいなと考えており、
このサイトを作成いたしました。<br>
お店を探してからお出かけ先を決めてもよし、現在地から検索して今日の旅先(ランチやディナー)を探すもよし、<br>
実際に行ってみてみんなにおすすめするもよし！<br>

みなさまにこのwebアプリを通じて、素敵なお店との出会い、発見、体験を提供できましたら幸いです。

# ⭐ER図
![空白の図](https://github.com/misato-tp/foodtravel/assets/138008284/0d5b22c7-0f84-43a6-acc5-1c5dbf00ed9f)


# ⭐メイン機能
## ✅お店の登録・閲覧
![2024-06-1720 03 22-ezgif com-speed](https://github.com/misato-tp/foodtravel/assets/138008284/edc702c3-ea5b-490e-934e-c70984cf668e)

登録画面には、ユーザーの入力補助とデータの統一のため、
- 郵便番号を入れると自動で住所が入力される機能
- 国名をインクリメンタルサーチで候補を出力
- 画像を選択した際にはプレビューを表示

<img width="600" alt="お店の詳細ページ" src="https://github.com/misato-tp/foodtravel/assets/138008284/4603208c-d851-44df-ba0b-312c7aeaafa0">

お店の詳細ページでは、
- 画像をメインとした表示
- google mapによる詳細な場所表示

ユーザーが視覚的にわかりやすく、周辺の建物を含め詳細にお店の場所がわかるように工夫をしました。
<br><br>

## ✅口コミ(レポ)の投稿・閲覧（ログイン必須）
<img width="1440" alt="スクリーンショット 2024-06-19 0 15 38" src="https://github.com/misato-tp/foodtravel/assets/138008284/2294e558-2be0-4110-9627-db7da65c20a3">

サイトで見つけたお店にもし行ったら、写真付きで感想をみんなでシェアできる機能です。<br>
おすすめ料理もピックアップして表記することができます。<br>

またログインの有無でレポの閲覧が変化するように設定しています(上画像：ログイン時、下画像：ログアウト時)。<br>
アカウント作成や、ログインをしたくなるような仕組みの1つです。

<img width="1000" alt="スクリーンショット 2024-06-19 0 15 38" src="https://github.com/misato-tp/foodtravel/assets/138008284/2ebf7be4-f5fc-4e4b-919d-61a7584ee7d6">

<img width="1000" alt="スクリーンショット 2024-06-19 0 21 51" src="https://github.com/misato-tp/foodtravel/assets/138008284/564deaa3-5520-41d6-8e5c-fa60e5a0bb08">

<br><br>

## ✅豊富な検索機能

<img width="1440" alt="スクリーンショット 2024-06-17 18 37 37" src="https://github.com/misato-tp/foodtravel/assets/138008284/c0f08faf-6fa5-443b-8348-b80470224c6a">

- キーワード検索<br>
店名と住所に対応しています。AND検索で2つを混ぜて検索もできます。<br>
お店の名前が全部は思い出せなかったり、住所があいまいでも検索すればヒットしやすくなるように工夫しました。

- ランダム検索<br>
登録されているお店の中から、1つランダムで選んでページを表示させます。<br>
ぱぱっと決めたいときに活用できます。

- 現在地周辺のお店を探す<br>
GooglemapAPI, Geocoderを使い、現在地を取得してお店を探せます。<br>
出先で急遽どこかいいお店がないか探したり、職場や自宅の近くにはどんなお店があるか探したいときに活用できます。

- 国から探す<br>
Google my mapを使い、各お店に関連づけている国の情報から、国ごとにお店を検索できます。<br>
食べたことない国のご飯が食べたいという時に活用できます。
<br><br>

## ✅いいね機能

![2024-06-1719 35 17-ezgif com-video-to-gif-converter](https://github.com/misato-tp/foodtravel/assets/138008284/a6d7e80b-a381-4581-8e6e-8040a9424458)

お気に入りのお店をすぐに探せるように、いいね機能を実装しました。
<br><br>

# ⭐使用技術
##### 言語
- Ruby(2.7.7)
##### フレームワーク
- Ruby on Rails(6.1.3.2)
##### データベース
- PostgreSQL(1.5.6)
##### フロントエンド
- Webpacker(5.4.4)
- bootstrap(5.3.3)
- jquery-rails(4.6.0)
##### ログイン機能
- Devise(5.0.0beta)
- omniauth-google-oauth2(1.1.2)
##### テスト
- RSpec
- Capybara
- FactoryBot
- Selenium WebDriver
- Rubocop-airbnb(6.0.0)
- bullet
##### ユーティリティ
- dotenv-rails
- ransack
- jp_prefecture
- geocoder
- carrierwave

# ⭐機能一覧
- ユーザー登録、ログイン機能(devise, omniauth-google-oauth)
- ゲストログイン機能
- 投稿機能
  - 画像投稿(carrierwave, AmazonS3)
  - 住所自動入力(jp_prefecture)
  - 画像プレビュー(jquery)
  - 国名検索(jquery)
- 表示機能
  - 住所からmapを表示(Google Maps JavaScript API)
  - ログインの有無によるレポの表示切り替え機能
- 検索機能
  - 位置情報検索(geocoder)
  - Google　my　Maps
  - キーワード検索(ransack)
- いいね機能(Ajax)
- ユーザー情報管理機能
  - 自分が投稿したお店、レポート一覧

# ⭐テスト
- RSpec
  - 機能テスト(request)
  - 統合テスト(system)
- Rubocop-airbnb

# ⭐今後の計画と反省
- (件数が増えてきたら)ページネーションを実装したい
- DockerやCircleCiにもう一度チャレンジしたい

DockerやCircleCiは途中で導入をするのではなく最初から導入するか決めておけばよかったと反省しています。<br>
またプログラミングスクールでは環境構築等は手順を決めていただいていたので、1から自分でおこなうものはかなり難しく感じました。<br>
公式のドキュメントの活用もうまくできず、2次リソースに頼りきってしまい解決が遅くなったこともあったので、<br>
正確な情報を正しく読み取る力をつけていきたいです。
