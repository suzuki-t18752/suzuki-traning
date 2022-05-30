### rails アクティブレコードについて
- 概要
  1. sqlの作成
  2. DBの更新
  3. インスタンスの作成(更新結果を入れる)
- .classメソッド
  - classの型を確認出来る
```
[5] pry(main)> def test
[5] pry(main)*   return 1
[5] pry(main)* end
=> :test
[6] pry(main)> test.class
=> Integer
[7] pry(main)> def test
[7] pry(main)*   false
[7] pry(main)* end
=> :test
[8] pry(main)> test.class
=> FalseClass
[9] pry(main)> def test
[9] pry(main)*   return false
[9] pry(main)* end
=> :test
[10] pry(main)> test.class
=> FalseClass
[11] pry(main)> def test
[11] pry(main)*   true
[11] pry(main)* end
=> :test
[12] pry(main)> test.class
=> TrueClass

#findとwhereで型が違う
[91] pry(main)> NameAbility.find_by(code: 'ss_provide_analytics').class
DEBUG   2021-11-30T14:17:06+09:00       application     reqid:nil       rid:nil uid:nil aid:nil
      NameAbility Load (1.2ms)  SELECT `name_abilities`.* FROM `name_abilities` WHERE `name_abilities`.`code` = 'ss_provide_analytics' LIMIT 1
=> NameAbility(id: integer, name: string, code: string, position: integer, created_at: datetime, updated_at: datetime)
[92] pry(main)> NameAbility.where(code: 'ss_provide_analytics').class
=> NameAbility::ActiveRecord_Relation
[93] pry(main)> NameAbility.find(1).class
DEBUG   2021-11-30T14:20:43+09:00       application     reqid:nil       rid:nil uid:nil aid:nil
      NameAbility Load (1.1ms)  SELECT `name_abilities`.* FROM `name_abilities` WHERE `name_abilities`.`id` = 1 LIMIT 1
=> NameAbility(id: integer, name: string, code: string, position: integer, created_at: datetime, updated_at: datetime)
```
- pluckメソッド
  - 配列で取り出す
  - ::ActiveRecord_Relation型でしか使えない(selectも)
```
[95] pry(main)> NameAbility.find(1).pluck(:id)
DEBUG   2021-11-30T14:23:08+09:00       application     reqid:nil       rid:nil uid:nil aid:nil
      NameAbility Load (1.3ms)  SELECT `name_abilities`.* FROM `name_abilities` WHERE `name_abilities`.`id` = 1 LIMIT 1
NoMethodError: undefined method `pluck' for #<NameAbility:0x000055d91b2a51f8>
from /home/suzuki/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/activemodel-6.0.3.6/lib/active_model/attribute_methods.rb:432:in `method_missing'
[97] pry(main)> NameAbility.where(code: 'ss_provide_analytics').pluck(:id)
DEBUG   2021-11-30T14:23:27+09:00       application     reqid:nil       rid:nil uid:nil aid:nil
       (1.2ms)  SELECT `name_abilities`.`id` FROM `name_abilities` WHERE `name_abilities`.`code` = 'ss_provide_analytics'
=> [20]
```
- delete
  - ActiveRecordを介さずsqlでそのままレコードを削除する
- destory
  - ActiveRecordを介して、レコードを削除する
  - モデルにdependent: :destoryが設定されていると設定されている関連テーブルのレコード削除する
  - ActiveRecordを介しているので、callbackメソッドやバリデーションを機能させることもでき

### sql 外部キー制約
```
親テーブル
CREATE TABLE 親テーブル名(親カラム名 データ型 PRIMARY KEY);

子テーブル
CREATE TABLE 子テーブル名
  (子カラム名 データ型,
   INDEX インデックス名(子カラム名),
   FOREIGN KEY 外部キー名(子カラム名) REFERENCES 親テーブル名(親カラム名))

CREATE TABLE db_name.tbl_name
  (col_name data_type, ...,
   FOREIGN KEY [index_name] (col_name, ...)
   REFERENCES tbl_name (col_name, ...)
   [ON DELETE reference_option] [ON UPDATE reference_option])

reference_option:
    RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT
```
- 子テーブルにデータを追加するとき、 FOREIGN KEY 制約が設定されたカラムには、親テーブルのカラムに格納されている値しか格納することができなくなります。
  - 親テーブルに存在しない値を含むデータを追加しようとするとエラーとなります。
- 親テーブル側のデータに対して削除をしたり更新したりしようとしたとき、対象となる値がすでに子テーブル側で使用されている場合には、エラーとなったり同時に削除や更新を行ったりという選択を行えます
  - データを削除した場合のふるまいは [ON DELETE reference_option]
  - データを更新した時のふるまいは [ON UPDATE reference_option]
  - RESTRICT
    - 親テーブルに対して削除または更新を行うとエラーとなります。設定を省略した場合は RESTRICT を設定したのと同じです。
  - CASCADE
    - 親テーブルに対して削除または更新を行うと、子テーブルで同じ値を持つカラムのデータに対して削除または更新を行います。
  - SET NULL
    - 親テーブルに対して削除または更新を行うと、子テーブルの同じ値を持つカラムの値が NULL になります。

### ロールバック
- DBの更新前にチェックポイントを設定し、更新処理の実施後に障害等が発生した場合、チェックポイントまで巻き戻す処理

### ロールフォワード
- コミット(更新処理の確定)が完了している際に障害が発生した場合に実施する
- バックアップを使い、バックアップの状態に戻してからトランザクションログ(ジャーナル)を使用して障害前までデータを戻す処理
