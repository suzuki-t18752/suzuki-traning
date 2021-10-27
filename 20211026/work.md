## fat controller , fat model
- それぞれが肥大化していること

- ちゃんとオブジェクト指向設計をすることが大事
- [良さそうな本](https://gihyo.jp/book/2016/978-4-7741-8361-9)

## layer レイヤー
- [参考](https://yoshi-it.com/what-is-software-layer/)
- 層、レベル
- 何かの構造や設計などが階層状になっているとき、それを構成する一つ一つの階層のことをレイヤー
- OSI参照モデルでは通信機能を物理層、データリンク層、ネットワーク層、トランスポート層、セッション層、プレゼンテーション層、アプリケーション層の7つレイヤーに分割して定義している




```
config/locales/controllers/admin/names.ja.yml
ja:
  controllers:
    admin/names:
      new:
        config_sheet_url_too_long: '設定ファイルのURLを３００文字以下で入力してください'
        XXXXXXXXXXXXXXXXXX: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
        YYYYYYYYYYYYYYY: ''




def config_sheet_url_validate
  return config_sheet_url.blank?
  return errors.add(:config_sheet_url, :config_sheet_url_too_long) if config_sheet_url.length >= 300

  parsed = nil
  begin
    parsed = URI.parse(config_sheet_url)
  rescue URI::InvalidURIError
    errors.add(:config_sheet_url, :XXXXXXXXXXXXXXXXXX)
  end
  return unless parsed
  return if parsed.is_a?(URI::HTTPS) && parsed.host == 'googl' && parsed.path == ''
  errors.add(:config_sheet_url, :YYYYYYYYYYYYYYY)
end
```
### バリデーション最終
```
def table_setting_sheet_url_validate
  return if table_setting_sheet_url.blank?
  return errors.add(:table_setting_sheet_url, :table_setting_sheet_url_too_long) if table_setting_sheet_url.length >= 300

  parsed = nil
  begin
    parsed = URI.parse(table_setting_sheet_url)
  rescue URI::InvalidURIError
    errors.add(:table_setting_sheet_url, :table_setting_sheet_url_invalid_char)
  end
  return unless parsed
  return if parsed.is_a?(URI::HTTPS) && parsed.host.include?('google') && parsed.path.include?('spreadsheets')
  errors.add(:table_setting_sheet_url, :table_setting_sheet_url_invalid)
end
```

### カラム設定や変数の名前を決める(これに限らないが)際、何が中に入るのかは明確にしておくこと
- 詳細が分かる名前設定を


### modelのテスト
- 今回はバリデーションのテスト

1. 分岐ごとにitを分けて''内に日本語で分岐条件を書く
2. subjectでテストするメソッドの指定
3. 有効な値の処理、DBが更新されるはずなので実行結果と予め用意した値を比べる処理を書く
  - it { expect(name.reload.table_setting_sheet_url).to eq(table_setting_sheet_url_value) }
4. 無効な値の処理、バリデーションのエラーが発生するのでメソッド自体をexpectして、想定しているエラーが発生しているのか確認する処理を書く
  - it { expect { table_setting_sheet_url_validate }.to raise_error(ActiveRecord::RecordInvalid) }
  - raise_errorでメッセージも確認出来る


```
#最終
describe 'table_setting_sheet_url_validate' do
  subject(:table_setting_sheet_url_validate) { name.table_setting_sheet_url_validate }
  let(:name) { create(:name, table_setting_sheet_url: table_setting_sheet_url_value) }

  context 'when valid url' do
    let!(:table_setting_sheet_url_value) { 'https://docs.google.com/spreadsheets/d/1N5L' }
    it { expect(name.reload.table_setting_sheet_url).to eq(table_setting_sheet_url_value) }
  end
  context 'when url is blank' do
    let!(:table_setting_sheet_url_value) { '' }
    it { expect(name.reload.table_setting_sheet_url).to eq(table_setting_sheet_url_value) }
  end
  context 'when invalid char in url' do
    let!(:table_setting_sheet_url_value) { '_https://docs.google.com/spreadsheets/d/1N5L' }
    it { expect { table_setting_sheet_url_validate }.to raise_error(ActiveRecord::RecordInvalid) }
  end
  context 'when http or https not included in url scheme' do
    let!(:table_setting_sheet_url_value) { 'ftp://docs.google.com/spreadsheets/d/1N5' }
    it { expect { table_setting_sheet_url_validate }.to raise_error(ActiveRecord::RecordInvalid) }
  end
  context 'when google not included in url host' do
    let!(:table_setting_sheet_url_value) { 'https://docs.yahoo.com/spreadsheets/d/1N5L' }
    it { expect { table_setting_sheet_url_validate }.to raise_error(ActiveRecord::RecordInvalid) }
  end
  context 'when spreadsheets not included in url path' do
    let!(:table_setting_sheet_url_value) { 'https://docs.google.com/sheets/d/1N5L' }
    it { expect { table_setting_sheet_url_validate }.to raise_error(ActiveRecord::RecordInvalid) }
  end
end
```

### push
- マイグレーションファイル、localsディレクトリのファイル、rspecのfactoriesディレクトリのファイルをセットでプルリクエストする
- マイグレーションファイルをpushする際はマイグレーション後に行う、schemaファイルも一緒に行う
- その他ファイルは別途プルリクエストする
