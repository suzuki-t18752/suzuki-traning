## factory_bot
[ドキュメント](https://www.rubydoc.info/gems/factory_bot/6.2.0)
[基礎](https://qiita.com/piggydev/items/32717b6c382272e2134e)
- rspecで扱うデータを生成する為のライブラリ


## rubyの書き方
- ハッシュ等が長くて複数行になる場合{}で囲うのではなくdo endを使う
```
#ok
let(:params) { { name: { name: new_name, config_sheet_url: new_config_sheet_url } } }

let(:params) do
    {
        name: attributes_for(:name).merge(
            company_id: nil,
            ledger_id: ledger.id,
            name_role_ids: [nameRole.find_by!(code: nameRole::STANDARD).id],
            config_sheet_url: config_sheet_url_value,
        ),
    }
end

#NG
let(:params) { 
    { 
        name: { 
            name: new_name, 
            config_sheet_url: new_config_sheet_url 
        } 
    } 
}
```

- ハッシュ等が長くて複数行になる場合のカンマ区切りは必ず後ろに付ける
```
#ok
let(:params) do
    {
        name: attributes_for(:name).merge(
            company_id: nil,
            ledger_id: ledger.id,
            name_role_ids: [nameRole.find_by!(code: nameRole::STANDARD).id],
            config_sheet_url: config_sheet_url_value,
        ),
    }
end

#NG
let(:params) do
    {
        name: attributes_for(:name).merge(
            company_id: nil
            , ledger_id: ledger.id
            , name_role_ids: [nameRole.find_by!(code: nameRole::STANDARD).id]
            , config_sheet_url: config_sheet_url_value
        ),
    }
end
```

## rails config/localsについて
- 言語設定用のファイル
- config/application.rbでデフォルトの言語を指定
- 下記のような形でファイルを設定する
```
ja:
  activerecord:
    models:
      name: 名前マスタ
    attributes:
      name:
        name: 名称
        name_katakana: 名称(カタカナ)
        phone: 電話番号
        zip_code: 郵便番号
      enumerize:
  enumerize:
    name:
      status:
        active: 有効
        suspended: 一時停止
        inactive: 無効
```

## URLのバリデーションの再考