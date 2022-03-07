## 展開代入
- ruby
  - 配列の中身をそれぞれ別の変数に代入出来る
  - 連想配列は配列に直してから展開する
```
[1] pry(main)> a,b,c = [1, 2, 3]
=> [1, 2, 3]
[2] pry(main)> a
=> 1
[3] pry(main)> b
=> 2
[4] pry(main)> c
=> 3
[5] pry(main)> a,b,c = {ab: 1, bc: 2, ca: 3}
=> {:ab=>1, :bc=>2, :ca=>3}
[6] pry(main)> a
=> {:ab=>1, :bc=>2, :ca=>3}
[7] pry(main)> b
=> nil
[8] pry(main)> c
=> nil
[9] pry(main)> ab,bc,ca = {ab: 1, bc: 2, ca: 3}
=> {:ab=>1, :bc=>2, :ca=>3}
[10] pry(main)> ab
=> {:ab=>1, :bc=>2, :ca=>3}
[11] pry(main)> bc
=> nil
[12] pry(main)> ab[:ab]
=> 1
[13] pry(main)> a,b,c = {ab: 1, bc: 2, ca: 3}.to_a
=> [[:ab, 1], [:bc, 2], [:ca, 3]]
[14] pry(main)> a
=> [:ab, 1]
[15] pry(main)> b
=> [:bc, 2]
[16] pry(main)> c
=> [:ca, 3]
```


- javascript
  - 配列はそのまま、連想配列は同じ変数名のものに代入出来る
```
> {d, e, f} = {a: 1, b: 2, c: 3}
> {a: 1, b: 2, c: 3}
> a
VM170:1 Uncaught ReferenceError: a is not defined
    at <anonymous>:1:1
(anonymous) @ VM170:1
> a
VM174:1 Uncaught ReferenceError: a is not defined
    at <anonymous>:1:1
(anonymous) @ VM174:1
> d
undefined
> f
undefined
> {a, b, c} = {a: 1, b: 2, c: 3}
{a: 1, b: 2, c: 3}
> a
1
> b
2
> c
3
> [ab, bc, ca] = [1, 2, 3]
(3) [1, 2, 3]
> ab
1
```
## フロントとバックエンド
- https://web.lingual-ninja.com/2019/07/backend-frontend.html
- 入力チェック、バリデーション
  - 両方に記述すべき
  - サーバーへのアクセスは多少なりとも時間が掛かるのでユーザーの使い勝手を考えるとフロントに実装すべき
  - ただセキュリティの関係上、フロント側はいくらでも改ざんできてしまうのでバックエンドにも実装しておくべき
  - 優先はバックエンド
- 画面の動作
  - フロント
- セキュリティー対策
  - バックエンド
- API連携
  - 基本的にはバックエンド側
  - 単純なhttpリクエストのやり取りだけならフロントのjavascriptでも出来るが、ブラウザによってはセキュリティの観点で複数のサーバーと通信を行うことを制限している場合があるのでバックエンドでやるのが無難


- データの加工
  - それぞれが送り先で扱えるような形にだけ直して投げようでいいのかな？
  - https://teratail.com/questions/66741
  - フロント→バックエンド
    - 多少のバリデーションだけして、基本的にはそのままバックエンドに投げる
    - フロント側のデータは改ざんが容易いのでバックエンドで確認、必要な形に形成して保存
  - バックエンド→フロント
    - フロントへ送る際は必要最低限のデータに絞るのは忘れない
    - 整形は基本的にフロントでよい
