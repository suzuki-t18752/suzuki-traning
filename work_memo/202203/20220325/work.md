- https://zenn.dev/riku/books/36d9873ee1c0e6/viewer/6e3636




## 遅延実行の意識を持っておこう
- 必要なものを必要なタイミングで使うことで無駄を省く
- メモリの節約等

- ジェネレータ
  - 結果、データを生成してくれるもののこと
  - イテレータ
    - 配列のようなデータ構造の要素(複数結果が得られるもの)を順に追っていく繰り返し処理等を簡単に記述出来る、オブジェクトや構文のこと


## active record associations
- https://railsguides.jp/association_basics.html

- belongs_to
  - 指定したテーブルのキーを持っている

- has_one
  - 指定したテーブルと対一の関係

- has_many
  - 指定したテーブルと対多の関係
  - テーブル名を複数系で指定する



## [mysql EXPLAIN(INDEXの確認)](https://dev.mysql.com/doc/refman/8.0/ja/explain.html)
- https://qiita.com/tsurumiii/items/0b70f1a1ee0499be2002
- 例
```
EXPLAIN SELECT * FROM users WHERE id = 1
```
```
結果
+----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
| id | select_type | table | partitions | type  | possible_keys | key     | key_len | ref   | rows | filtered | Extra |
+----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
|  1 | SIMPLE      | users | NULL       | const | PRIMARY       | PRIMARY | 4       | const |    1 |   100.00 | NULL  |
+----+-------------+-------+------------+-------+---------------+---------+---------+-------+------+----------+-------+
```

- id 実行順序
- select_type
  - SIMPLE: 単純な SELECT (UNION やサブクエリーを使用しません)
  - PRIMARY: もっとも外側の SELECT
  - UNION: UNION 内の 2 つめ以降の SELECT ステートメント
  - DEPENDENT: UNION 内の 2 つめ以降の SELECT ステートメントで、外側のクエリーに依存します
  - UNION RESULT: UNION の結果。
  - SUBQUERY: サブクエリー内の最初の SELECT
  - DEPENDENT SUBQUERY: サブクエリー内の最初の SELECT で、外側のクエリーに依存します
  - DERIVED: 派生テーブル SELECT (FROM 句内のサブクエリー)
  - MATERIALIZED: 実体化されたサブクエリー
  - UNCACHEABLE SUBQUERY: 結果をキャッシュできず、外側のクエリーの行ごとに再評価される必要があるサブクエリー
  - UNCACHEABLE UNION: キャッシュ不可能なサブクエリーに属する UNION 内の 2 つめ以降の SELECT
- table	対象テーブル
- partitions	テーブルパーティション
- type
  - system: テーブルに1行しかない
  - const: プライマリキー、ユニークキーのルックアップによるアクセス
  - eq_ref: joinにおいてのconstと同義
  - ref: constでないインデックスを使って等価検索
  - range: indexを用いた範囲検索
  - index: フルインデックススキャン
  - ALL: フルテーブルスキャン
  - fulltext: FULLTEXTインデックスによる検索
  - ref_or_null: refに追加でNULL値でも検索する
  - index_merge: インデックスマージ最適化を使用
  - unique_subquery: 効率化のため、サブクエリーを完全に置き換える単なるインデックスルックアップ関数
  - index_subquery: 働きは、unique_subqueryと同様。サブクエリー内の一意でないインデックスに対して機能する
- possible_keys	optimizerがテーブルのアクセスに利用可能だと判断したインデックス
- key	実際にoptimizerによって使用されたキー
- key_len	選択されたキーの長さ
- ref
  - 定数の場合: const
  - JOINを使用している場合: 結合する相手側のテーブルで検索条件として利用されているカラムが表示される
- rows	対象テーブルから取得される行の見積もり
- filtered	テーブル条件によってフィルタ処理される行の推定の割合
- Extra	optimizerがどのような戦略を立てたかを知ることが出来る
