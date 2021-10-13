### railsのチェックボックス
[railsチェックボックス](https://railsdoc.com/page/check_box)

<%= check_box 'some_valueg', '', {checked: true, id: 'test'}, instance.id, nil %>

<%= check_box nameの値(some_valueg[]で表示), nameの[]の値, {オプション(checked:チェックを最初から入れるか id: idの値を指定)}, チェックが入っている場合のvalueの値, チェックが入っていない場合のvalueの値(チェックが入っていない場合用のinputタグが作成される、nilだとタグがなくなる) %>

### railsのクエリログ
config/ansible/roles/fluentd/files/staging/td-agent.confファイル内に記載された場所

今回  
path /opt/suzuki/current/log/application.log

### 改修作業流れ
1. 要件の確認(改修内容、改修理由)
2. だいたいのスケジュールをたてる
3. 改修箇所の確認
  - 画面の確認
  - 関係DB,table
  - 作業ファイル
  - 処理の流れ
    - 簡単なあらまし
    - データの流れ
4. 改修内容の確認
  - 作業後の画面
  - 作業後の処理の流れ
  - 具体的な処理の変更方法
5. 作業実施
6. テスト

## git
### hotfix
緊急性の高いバグの修正等
https://e-words.jp/w/%E3%83%9B%E3%83%83%E3%83%88%E3%83%95%E3%82%A3%E3%83%83%E3%82%AF%E3%82%B9.html
### feature
新機能の作成や緊急性のない改修等
https://e-words.jp/w/%E3%83%95%E3%82%A3%E3%83%BC%E3%83%81%E3%83%A3%E3%83%BC.html

### 基本操作
1. ローカルのサブブランチにてadd,commit,push
2. リモートのサブブランチにてpullrequest、merge
3. ローカルのメインブランチにてpull