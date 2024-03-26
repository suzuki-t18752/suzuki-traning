# railsのメモ

## 新規テーブル作成
```
rails g model モデル名
rails g model Test
```
- マイグレーションファイルの編集
- モデルファイルの編集
- localeの定義
- specモデルテストファイルの作成
- factorybotファイルの作成

## localeの設定
- テーブル名やカラム名を設定した言語で表示する為の設定
```
ja:
  activerecord:
    models:
      name: 名前マスタ
    attributes:
      name:
        name: 名称
        name_katakana: 名称(カタカナ)
        status: ステータス
      enumerize:
  enumerize:
    name:
      status:
        normal: 通常
        katakana: カタカナ




日本語の呼び出し方
モデル名
[1] pry(main)> Name.model_name.human
=> "名前マスタ"
カラム名
[3] pry(main)> Name.human_attribute_name(:name)
=> "名称"
enumerize
[2] pry(main)> Name.first.status_text
=> "通常"
```

## 日付の計算
```
[1] pry(main)> Time.now + 1.day
=> 2022-07-01 14:14:25.8902775 +0900
[2] pry(main)> Time.now + 2.days
=> 2022-07-02 14:14:30.4614213 +0900
[3] pry(main)> Time.now + 2.day
=> 2022-07-02 14:14:57.1363041 +0900
[4] pry(main)> Time.now + 2.days
=> 2022-07-02 14:15:01.2179815 +0900
[6] pry(main)> Time.now + 1.second
=> 2022-06-30 14:15:16.3675628 +0900
[7] pry(main)> Time.now + 1.seconds
=> 2022-06-30 14:15:17.8957472 +0900
[11] pry(main)> Time.now + 1.minute
=> 2022-06-30 14:16:37.5275331 +0900
[12] pry(main)> Time.now + 2.minute
=> 2022-06-30 14:17:42.3341992 +0900
[13] pry(main)> Time.now + 1.month
=> 2022-07-30 14:15:49.2873874 +0900
# 週初めの日付を取得(始まりの曜日を指定出来る)
[5] pry(main)> Time.zone.today.beginning_of_week(:sunday)
=> Sun, 01 Oct 2023
```

## ActiveModel
- optional: true
  - nilを許容するかどうか
  - デフォルトはfalseでnilを許容しない

### 外部結合
```
Model.left_joins(:join_table)

結合先の検索
Model.left_joins(:join_table).where(join_table: { id: 1 })
```

### OR検索
```
Modelモデルのidが1もしくはnilのものを検索できる(SELECT * FROM models WHERE id = 1 OR id IS NULL)
Model.where(id: 1).or(Model.where(id: nil))

結合をしている場合(Modelのidが1もしくはJoinTableのidが1のものを検索)
Model.left_joins(:join_table).where(id: 1).or(JoinTable.where(id: 1))
```

### exists?
存在チェックが出来る
```
[2] pry(main)> A.exists?(id: 1)
DEBUG   2024-02-21T14:49:44+09:00       application     reqid:nil       rid:nil uid:nil aid:nil
      A Exists? (3.4ms)  SELECT 1 AS one FROM `As` WHERE `As`.`id` = 1 LIMIT 1
=> true
[3] pry(main)> A.exists?(id: 2)
DEBUG   2024-02-21T14:49:52+09:00       application     reqid:nil       rid:nil uid:nil aid:nil
      TlImage Exists? (1.2ms)  SELECT 1 AS one FROM `As` WHERE `As`.`id` = 1 LIMIT 1
=> false
```

## ActiveRecord
- ActiveRecordの変更を行った際にmodelの確認を忘れないように
- DBの中身によっては変更を行えないこともあるので確認を忘れない
  - 例: そのカラムにnullが入っているにも関わらずnot null制約を入れようとした場合
    - 予めそのカラムがnullでないようにそのレコードを削除したり、値を入れるようにする
## active record associations
- https://railsguides.jp/association_basics.html

- belongs_to
  - 指定したテーブルのキーを持っている

- has_one
  - 指定したテーブルと対一の関係

- has_many
  - 指定したテーブルと対多の関係
  - テーブル名を複数系で指定する

- カラム名に関連テーブルとは別名を指定していた場合
- optional
  - 外部キーにnilを入力する場合
  ```
  belongs_to :test_user, class_name: 'User', optional: true
  ```

### 外部キー制約
- on_delete
  - nullify
    - 紐づいているレコードが削除された際に設定したカラムにnullが入る
  - cascade
    - 紐づいているレコードが削除された際に設定したレコードも削除される
- 外部キー制約の変更
　- 関連条件に注意！
    - 1対多であれば複数系
    - 1対1であれば単数形
  - 1度削除を行ってから追加する必要がある
  - 下記のように複数テーブルまとめて行える
  ```
  class UpdateForeignKeyOfUploadImages < ActiveRecord::Migration[6.1]
    def change
      remove_foreign_key :gg_upload_images, :image_files, on_delete: :nullify
      add_foreign_key :gg_upload_images, :image_files, on_delete: :cascade

      remove_foreign_key :hh_upload_images, :image_files, on_delete: :nullify
      add_foreign_key :hh_upload_images, :image_files, on_delete: :cascade
    end
  end
  ```
  - 別名を指定する(同じテーブルの外部キーを複数カラムに指定する場合)
  ```
  t.references :a_user, type: :integer, foreign_key: { to_table: :users, on_delete: :nullify }, comment: 'AID'
  t.references :b_user, type: :integer, foreign_key: { to_table: :users, on_delete: :nullify }, comment: 'BID'
  ```
- indexの定義
  - nameは基本なしで良い、デフォルトで勝手に設定してくれる
  ```
  add_index :gg_upload_images, :name, unique: true, name: 'uidx_gg_upload_images'
  ```

### リレーションテーブルもまとめて作成する
```
下記のように関係テーブルを属性に指定すること
Review.create!(
  id: 1,
  review_id: '1',
  review_receptions: [ReviewReception.new(reception_type: 'dinner'), ReviewReception.new(reception_type: 'etc')]
)
```

## rails whenever
- railsでcronを管理するライブラリ
  - cron
    - 設定されたスケジュールで定期的にプログラムを実行してくれるUNIX系OSの常駐プログラム。
  - crontab
    - スケジュールの追加、変更、削除を行うコマンド。
    - このコマンドの実行によってcrontabファイルというものに、どのプログラムをいつ実行するかが記録される。このスケジュールをもとにcronがプログラムを実行する。
  - whenever
    - crontabファイルの設定をrails上で記述できるようにするGem。
- config/scheduleディレクトリに設定ファイルを置く
```
基本: 分 時 日 月 曜日 [実行するコマンドやプログラム]

#1時間おきに実行する
every :hour do
  :
end

#毎週日曜日の午後12時に実行する
every :sunday, at: '12pm' do
  :
end

#毎月27日から31日の0時0分に実行する
every '0 0 27-31 * *' do
  :
end
```
