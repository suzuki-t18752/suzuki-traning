## constantize
- 文字列からクラスを検索してくれる


## [Zeitwerk](https://github.com/fxn/zeitwerk)
- reqire等をしなくてもコードを読み込んでくれるライブラリ
- rails6ではgemで入れられる
- ファイル名の命名規則とclassの命名規則を用いて読込をする
https://railsguides.jp/autoloading_and_reloading_constants.html

## serializerの設定読込
- config/apprication.rbにactive_jobの設定をする、今回はsidekiq
  - Active Jobは、Sidekiq、Resque、Delayed Jobなどさまざまなキューイング(キューを使った要素の管理)バックエンドに接続出来る
  - config.active_job.queue_adapter = :sidekiq
- 下記のconfig/initializers/custom_serializers.rbを作成
```
Rails.application.to_prepare do
  Rails.application.config.active_job.custom_serializers << Serializers::ValueSerializer
end
```
- to_prepareを付けることで再読み込みが行われるが再読み込みを行った際にactive_jobは古いオブジェクトが残り続ける為、付ける必要がない
- サーバーの再起動が必須、active_jobが読み込まれるのと同じタイミングで再読み込みさせるべき
```
#最終
Rails.application.config.active_job.custom_serializers << Serializers::ValueSerializer
```
- config/apprication.rb内のconfig.cache_classesがfalseだとファイル更新時に自動再読み込みが行われる
  - しかしserializerは古いオブジェクト(active_jobの影響)が残り続ける為、そのままactive_jobを使用するとエラーになる
  - なので毎回サーバーの再起動が必要になる
  - trueにすると自動読込されなくなる,本番環境はtrueになっている
```
  config.cache_classes = true
```
