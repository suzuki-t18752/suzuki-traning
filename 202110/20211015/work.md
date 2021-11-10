## テストの報告について
1. 改修、作成内容
2. 作業、確認URL
3. テスト環境の記載、準備方法
4. テスト前の状態
  - DBの状態
  - 画面の状態
5. テストの流れ
  - 作業の流れを動画でキャプチャ等
6. テスト項目、確認事項
7. テスト後の状態、結果


## rspec
### let

- どちらもitの中で1回だけ
- let! 一番最初に呼び出される
- let 最初に使われた時に呼び出される(遅延実行)

1. letの呼び出し回数は3回
```
describe 'GET #bulk_edit' do
  let(xxxx)
  it '' do xxxx end
  it '' do xxxx end
  it '' do xxxx end
end
```

2. letの呼び出し回数は2回
```
describe 'GET #bulk_edit' do
  let(xxxx)
  it '' do xxxx end
  it '' do xxxx end
  it '' do yyyy end
end
```
3. letの呼び出し回数は3回
```
describe 'GET #bulk_edit' do
  let!(xxxx)
  it '' do xxxx end
  it '' do xxxx end
  it '' do yyyy end
end
```

### メソッドの呼び出し順番
例
expect(assigns(:rt_table_periods)).to match_array([rt_table_period, rt_table_period1, rt_table_period2])

- 左から右
- 中から外

1. :rt_table_periods
2. assigns()
3. expect()
4. rt_table_period
5. rt_table_period1
6. rt_table_period2
7. match_array()
8. .to

## DSL【Domain-Specific Language】
[参考](https://www.fenet.jp/infla/column/technology/dsl%E3%81%A8%E3%81%AF%EF%BC%9F%E5%9F%BA%E7%A4%8E%E7%9F%A5%E8%AD%984%E3%81%A4%E3%82%92%E3%82%8F%E3%81%8B%E3%82%8A%E3%82%84%E3%81%99%E3%81%8F%E8%A7%A3%E8%AA%AC%EF%BD%9C%E5%9B%9E%E7%B7%9A%E3%81%AB/)
- ドメイン固有言語
- 特定の作業の遂行や問題の解決に特化して設計されたコンピュータ言語。特定用途向けのプログラミング言語やマークアップ言語、モデリング言語などが該当する


## ! (エクスクラメーション) save!やupdate!等
!を付けないとnilが帰ってくるが、!を付けることでActiveRecord::RecordNotFoundエラーを発生させることが出来る
例外処理を発生させることが出来る