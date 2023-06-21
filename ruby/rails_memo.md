# railsのメモ
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

## ActiveRecord
- ActiveRecordの変更を行った際にmodelの確認を忘れないように
- DBの中身によっては変更を行えないこともあるので確認を忘れない
  - 例: そのカラムにnullが入っているにも関わらずnot null制約を入れようとした場合
    - 予めそのカラムがnullでないようにそのレコードを削除したり、値を入れるようにする
### 外部キー制約
- on_delete
  - nullify
    - 紐づいているレコードが削除された際に設定したカラムにnullが入る
  - cascade
    - 紐づいているレコードが削除された際に設定したレコードも削除される
- 外部キー制約の変更
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
