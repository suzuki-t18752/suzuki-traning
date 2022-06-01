### ttl(Time to live)
- 有効期間、寿命

- ネットワークで登場するTTL
  １．数字である
  ２．機器を1つ経由する毎に数字を1減らす
  ３．数字が「0」になったら、その時点で中継を止める
  - パケット（通信用に細切れにしたデータ）にくっつく情報で、パケットがネットワークの世界で永遠に放浪する事態が回避される

- DNSの世界におけるTTLは単純に「有効期限」
  - キャッシュの有効期限です。
  - DNS関連のお仕事をしているDNSサーバには２種類ある
    １．フルサービスリゾルバ（DNSキャッシュサーバ）
      - フルサービスリゾルバは、どんな手を使おうと問い合わせに答える
      - もし自分で答えが分からなければ、他のDNSサーバに答えを教えてもらいに行く
    ２．権威DNSサーバ
      - 自分の持っている情報を教えてあげるのが仕事
  - フルサービスリゾルバさんは分からないことがあると権威DNSサーバに問い合わる
  - 何回も同じ内容を問い合わせないように問い合わせた内容をキャッシュする
  - このキャッシュを確認して答えが無かった場合に権威DNSサーバに問い合わせを行う
  - ただ日々情報が更新されているのでいつまでも古い情報をキャッシュしておくわけにはいかないのでその期間設定がttl

### 排他制御
- https://qiita.com/NagaokaKenichi/items/73040df85b7bd4e9ecfc
- あるファイル(資源)に対して何か操作を行っている場合に、他の誰かが同じファイルに操作を行わないようにする制御
  - 楽観ロック（楽観的排他制御）
    - 楽観ロックとは、めったなことでは他者との同時更新は起きないであろう、という楽観的な前提の排他制御。
    - データそのものに対してロックは行わずに、更新対象のデータがデータ取得時と同じ状態であることを確認してから更新することで、データの整合性を保証する方式
    - バージョンを管理する値を持たせてデータの取得時、更新時に比較することで保障を行う(更新日時等でも出来る)
  - 悲観ロック（悲観的排他制御）
    - 他者が同じデータに頻繁に変更を加えるであろう、という悲観的な前提の排他制御。
    - 更新対象のデータを取得する際にロックをかけることで、他のトランザクションから更新されないようにする方式
    - なんらかの障害(ブラウザを×ボタンで落とした)によりロックが解除されなくなってしまう場合があるのでタイムアウト機能や管理者権限等でロックを解除出来るようにする方法を用意しておかなければいけない

### 分散ロック
- 分散ロックは悲観ロック
- リソースは不特定多数のクライアントにより常に変更されるものという前提で、 リソースの参照時に恒常的にロックをかける
- 複数の環境から１つのリソースに対して処理を行えないようにすること
### 分散ロックマネージャ
- DLM(Distributed Lock Manager)

## Redlock(redisで使う分散ロックマネージャ)
- https://cam-inc.co.jp/p/techblog/461029949445243945
- https://github.com/leandromoreira/redlock-rb
- 詳細
  1. ロックするリソースとロック時間を設定
  2. そのリソースと同じものがロックされているか確認
    - ロックされていない場合は設定したリソースをロック
    - ロックされている場合はそのロックが有効なのか確認する(時間で)
      - ロックがまだ有効な場合はfalseを返す
      - ロックが有効でない場合設定したリソースをロックし、そのロック情報を返す