### rspec letの実行タイミングを改めて意識する
```
  let(:name) { create(:name) }

  describe '#index' do
    before(:each) { get admin_name_seat_create_templates_path(name) }
    let!(:template_with_aaa_table) do
      table = create(:shared_table)
      create(:seat_create_template, name: name, table: table) do |template|
        create(:seat_create_status, :aa, :succeeded, seat_create_template: template)
        create(:seat_create_status, :bb, :succeeded, seat_create_template: template)
      end
    end
    let!(:template_without_aaa_table) do
      create(:seat_create_template, name: name) do |template|
        create(:seat_create_status, :aa, :waiting, seat_create_template: template)
        create(:seat_create_status, :hp, :waiting, seat_create_template: template)
      end
    end
    let!(:aa_table1) { create(:aa_table, name: name) }
    let!(:aa_table2) { create(:aa_table, name: name, deleted_on_site: 1) }
    let!(:bb_table1) { create(:bb_table, name: name) }
    let!(:bb_table2) { create(:bb_table, name: name, deleted_on_site: 1) }
    it do
      expect(response.status).to eq 200
      expect(response.body).to include('AAAA：1')
      expect(response.body).to include('BBBB：1')
    end
  end
```
- letよりも先にbefore,getリクエストが実行されてしまい、let!でDBに入れられているはずのデータが登録されていない為、テストがうまくいかない
↓　
```
  let(:name) { create(:name) }

  describe '#index' do
    subject(:request) { get admin_name_seat_create_templates_path(name) }
    let!(:template_with_aaa_table) do
      table = create(:shared_table)
      create(:seat_create_template, name: name, table: table) do |template|
        create(:seat_create_status, :aa, :succeeded, seat_create_template: template)
        create(:seat_create_status, :bb, :succeeded, seat_create_template: template)
      end
    end
    let!(:template_without_aaa_table) do
      create(:seat_create_template, name: name) do |template|
        create(:seat_create_status, :aa, :waiting, seat_create_template: template)
        create(:seat_create_status, :bb, :waiting, seat_create_template: template)
      end
    end
    let!(:aa_table1) { create(:aa_table, name: name) }
    let!(:aa_table2) { create(:aa_table, name: name, deleted_on_site: 1) }
    let!(:bb_table1) { create(:bb_table, name: name) }
    let!(:bb_table2) { create(:bb_table, name: name, deleted_on_site: 1) }
    it do
      request
      expect(response.status).to eq 200
      expect(response.body).to include('AAAA：1')
      expect(response.body).to include('BBBB：1')
    end
  end
```

### シェルスクリプトのループ
```
#!bin/bash

for ((i=7 ; i<52 ; i++))
do
  mysql -uaaa -ppassword -h 127.0.0.1 -P 33060 aaa_development -e"INSERT INTO tl_tables(name_id, code, created_at, updated_at) VALUES(1, $i, 'test1''2021-11-02 14:33:26', '2021-11-02 14:33:26');"
done
```

## mysql暗黙の型変換
[整数型](https://dev.mysql.com/doc/refman/5.6/ja/integer-types.html)
[参考](https://sakaik.hateblo.jp/entry/20210426/mysql_string_number_auto_exchange_bikkuri)

- mysqlは比較演算子の右辺か左辺どちらか片方が数値型の場合、両方の辺を数値型として扱い変換する
```
mysql> SELECT '1,234,567' + 3;
+-----------------+
| '1,234,567' + 3 |
+-----------------+
|               4 |
+-----------------+
```
- 左辺の｢1｣までが数値と認識され｢,234,567｣は切り捨てられて計算された

```
mysql> select id, name from gn_tables;
+----+------------------+
| id | name             |
+----+------------------+
|  1 | テーブル1        |
|  2 | テーブル2        |
|  3 | テーブル3        |
|  4 | テーブル4        |
+----+------------------+
4 rows in set (0.01 sec)
mysql> select id, name from tables where name = 'テーブル1';
+----+-----------+
| id | name      |
+----+-----------+
|  1 | テーブル1  |
+----+-----------+
1 row in set (0.01 sec)

mysql> select id, name from tables where name = 0;
+----+------------------+
| id | name             |
+----+------------------+
|  1 | テーブル1         |
|  2 | テーブル2         |
|  3 | テーブル3         |
|  4 | テーブル4         |
+----+------------------+
4 rows in set, 4 warnings (0.01 sec)
mysql> select id, name from gn_tables where name = 1;
Empty set, 4 warnings (0.00 sec)
```
- 文字列しかない場合は0に変換される
```
mysql> select '123fbfbf' + 3;
+----------------+
| '123fbfbf' + 3 |
+----------------+
|            126 |
+----------------+
1 row in set, 1 warning (0.00 sec)
```
- 左から数値として認識出来る部分までを数値として扱いそれ以外を切り捨てる


### RubyのライブラリであるMySQLドライバーのmysql2による型変換
[ソース](https://github.com/brianmario/mysql2/blob/9307dd9869b64b8e4e19f1a3d1286756fc14355f/lib/mysql2/client.rb#L9)
```
cast_booleans: false,        # cast tinyint(1) fields as true/false in ruby
```
- tinyint(1)型をtrue/falseに変換する設定がある

### rubyのリテラル(書き方)
[参考](https://docs.ruby-lang.org/ja/latest/doc/spec=2fliteral.html)
