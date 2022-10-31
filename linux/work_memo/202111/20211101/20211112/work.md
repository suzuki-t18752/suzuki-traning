### rspec model バリデーションテスト
- inclusion
```
it 'validate for gn_table_publish' do
    is_expected.to allow_value(true).for(:gn_table_publish)
    is_expected.to allow_value(false).for(:gn_table_publish)
    is_expected.not_to allow_value(nil).for(:gn_table_publish)
end
```
### rspec described_class
- ClassNameを参照するためのメソッド


### モック(mock)
- モックアップの略
- 中身がない外見だけのもの、イメージ、試作品の模型、見本

- テストで使うモック的なもの
	- テストスタブ (テスト対象に「間接的な入力」を提供するために使う。)
	- テストスパイ (テスト対象からの「間接的な出力」を検証するために使う。出力を記録しておくことで、テストコードの実行後に、値を取り出して検証できる。)
	- モックオブジェクト (テスト対象からの「間接的な出力」を検証するために使う。テストコードの実行前に、あらかじめ期待する結果を設定しておく。検証は-オブジェクト内部で行われる。)
	- フェイクオブジェクト (実際のオブジェクトに近い働きをするが、より単純な実装を使う。例として、実際のデータベースを置き換えるインメモリデータベースが挙げられる。)
	- ダミーオブジェクト (テスト対象のメソッドがパラメータを必要としているが、そのパラメータが利用されない場合に渡すオブジェクト。)

```
it 'エラーなく予報をツイートすること' do
  # Twitter clientのモックを作る
  twitter_client_mock = double('Twitter client')
  # updateメソッドが呼びだせるようにする
  allow(twitter_client_mock).to receive(:update)

  weather_bot = WeatherBot.new
  # twitter_clientメソッドが呼ばれたら上で作ったモックを返すように実装を書き換える
  allow(weather_bot).to receive(:twitter_client).and_return(twitter_client_mock)

  expect{ weather_bot.tweet_forecast }.not_to raise_error
end
```
### doubleメソッド
- モックオブジェクトを作成する
- 実際のオブジェクトの変わりになるもの

### allowとreceive
- allow(モックオブジェクト).to receive(メソッド名)
- モックオブジェクトが実際のオブジェクトのメソッドを呼び出せるように設定する

### and_return
- receive(メソッド名)で呼び出されるメソッドの処理結果を置き換える
