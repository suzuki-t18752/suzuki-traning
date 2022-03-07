- apiを確認するエディター
  - editor.swagger.io

### github actionsがThis check failedになった場合
- 下記メッセージが出る
```
The job was not started because recent account payments have failed or your spending limit needs to be increased. Please check the 'Billing & plans' section in your settings.
```
- githubの管理者にactionsの使用上限を上げてもらうか、リセットされるのを待つ


- [ ] ぐるなびの予約受付可否チェックのバッチ処理時にレスラク管理の可否チェックを行う処理を追加
- [×] 卓一括作成時の席ID取得処理にリトライ処理を追加する(5秒後ぐらいに1回だけ)
- [ ] コース作成時のコースが作成されたかの確認処理時にリトライ処理を追加する(5秒後ぐらいに1回だけ)
- [ ] コース作成処理のロックを行う
