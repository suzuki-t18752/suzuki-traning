```
#マイグレーションファイルに下記2行を追加する
#20211020034827_add_config_sheet_url_to_names.rb
# frozen_string_literal: true
# nodoc
class AddConfigSheetUrlTonames < ActiveRecord::Migration[6.0]
    def change
      add_column :names, :config_sheet_url, :string, limit: 300, null: true, default: nil, comment: '設定シートURL', after: :memo
    end
end

```

## エディターの設定で最後の行に改行が入るようにする
```
#vscodeの設定を開く

#検索に下記を入れる
files.insertFinalNewline

#チェックボックスにチェックを入れる

```

### 最終行以降の複数空白行を消す
trimFinalNewlines

### 行末の空白を消す
files.trimTrailingWhitespace


## URLのバリデーションをライブラリで行うよう変更する
url_string = 'https://medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494'
parsed = URI.parse(url_string)
parsed.is_a?(URI::HTTP)


### is_a?()
- ()内の形式になっているのかを確認し、true or falseを返す
- 例　parsed.is_a?(URI::HTTP)
- 例　parsed.is_a?(Array)

### URIモジュール
```
url_string = 'https://d.medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494'
=> "https://d.medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494"
parsed = URI.parse(url_string)
=> #<URI::HTTPS https://d.medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494>

p uri = URI.parse("http://www.ruby-lang.org/")
# => #<URI::HTTP:0x201002a6 URL:http://www.ruby-lang.org/>
p uri.scheme    # => "http"
p uri.host      # => "www.ruby-lang.org"
p uri.port      # => 80
p uri.path      # => "/"
```

```
url_string = 'httpts://d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494'
=> "httpts://d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494"
parsed = URI.parse(url_string)
=> #<URI::Generic httpts://d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494>

url_string = 'cshttp://d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494'
=> "cshttp://d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494"
parsed = URI.parse(url_string)
=> #<URI::Generic cshttp://d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494>

url_string = 'http://d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494'
=> "http://d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494"
parsed = URI.parse(url_string)
=> #<URI::HTTP http://d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494>

url_string = 'http:cscs//d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494'
=> "http:cscs//d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494"
parsed = URI.parse(url_string)
=> #<URI::HTTP http:cscs//d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494>

url_string = 'http:/vs/d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494'
=> "http:/vs/d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494"
parsed = URI.parse(url_string)
=> #<URI::HTTP http:/vs/d..medium.com/@henryyihengzhang/validating-urls-in-ruby-c3e4646c6494>
```

### 方法

URI.parse(url_string).is_a?(URI::HTTP)
```
def url_valid?
    URI.parse(config_sheet_url).is_a?(URI::HTTP)
end

純粋にメソッドを呼び出して判定する
↓
他のバリデーションと判定タイミングが変わる
メッセージの設定がしにくい
↓
:ifや:unlessでシンボルを使う
バリデーションの実行直前に呼び出されるメソッド名をシンボルで:ifや:unlessオプションに指定することもできます。 これは最も頻繁に使われるオプションです。

validates :config_sheet_url, presence: true, if: :def url_valid?

def url_valid?
    URI.parse(config_sheet_url).is_a?(URI::HTTP)
end
↓
そもそも使い方が違う
この判定でバリデーションをするか決める為の設定
↓
カスタムバリデーションを使う
validate :config_sheet_url_validate
def config_sheet_url_valid
    parsed = URI.parse(config_sheet_url)
    unless config_sheet_url.blank? or (config_sheet_url.length <= 300 and parsed.is_a?(URI::HTTP))
    errors.add(:config_sheet_url, "を３００文字以下で有効なURLを入力してください")
    end
end
↓
下記エラーが発生する
bad URI(is not URI?): "test_https://doc.....google.com/spreadsheets/d/1N5LQ554LYyPNy6Z__ZZkhgGNeW22bI3d9V7NLbuSnE0/edit#gid=0"

URIモジュールの使用時にURLに入れられない文字 "_", "|"等がhttpの前後(scheme部分)に入った場合に発生する

↓
例外処理を加える
def config_sheet_url_validate
    unless config_sheet_url.blank? || (config_sheet_url.length <= 300 && URI.parse(config_sheet_url).is_a?(URI::HTTP))
      errors.add(:config_sheet_url, 'を３００文字以下で有効な値を入力してください')
    end
  rescue URI::InvalidURIError # URI.parseの際にhttpの前後(scheme部分)に"_"や"|"等のURLに入力出来ない値が入ると発生するエラー
    errors.add(:config_sheet_url, 'を３００文字以下で有効な値を入力してください')
  end

↓
rspecでテストをする
下記エラーが発生
rspec spec/requests/admin/names_controller_spec.rb:160
Run options:
  include {:locations=>{"./spec/requests/admin/names_controller_spec.rb"=>[160]}}
  exclude {:e2e=>true}
FF.

Failures:

  1) Admin::namesController POST /admin/names with valid params
     Failure/Error: @name = ::name.new(name_params)

     ActiveModel::UnknownAttributeError:
       unknown attribute 'config_sheet_url' for name.
↓
テーブルにURLのカラムが存在しない為
マイグレーションしてカラムを追加

ブランチを移動した際にブランチ事に編集しているファイルが違うことを忘れないように
```
↓
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



## マイグレーションファイルのテストでエラーがでているので修正


## 設定シートURLの名前をもっと詳細の分かるように config_sheet_url
