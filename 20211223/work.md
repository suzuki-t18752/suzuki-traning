## [Zeitwerk](https://github.com/fxn/zeitwerk)
- reqire等をしなくてもコードを読み込んでくれるライブラリ
- rails6ではgemで入れられる
- ファイル名の命名規則とclassの命名規則を用いて読込をする


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

↓
# Rubyには、メモリ上のクラスやモジュールを真の意味で再読み込みする手段もなければ、既に利用されているすべてのクラスやモジュールに再読み込みを反映する手段もない
https://railsguides.jp/autoloading_and_reloading_constants.html#config-autoload-once-paths
↓
- initializerに設定されているものはアプリの起動時にしか読み込みが行われない
  - to_prepareを付けることで再読み込みを行わせることが出来る
↓
active_jobにエンキューされたオブジェクトは再読み込みされることがない
↓
- config.autoload_once_paths << "#{config.root}/app/serializers"
  - autoload_once_pathsを設定することでアプリの起動時のみ読み込みがされるよう設定する
  - これをしないとアプリ起動時やrails cでコンソールを開いた際に警告が発生する
```
DEPRECATION WARNING: Initialization autoloaded the constants Serializers and Serializers::ArgumentSerializer.

Being able to do this is deprecated. Autoloading during initialization is going
to be an error condition in future versions of Rails.

Reloading does not reboot the application, and therefore code executed during
initialization does not run again. So, if you reload Serializers, for example,
the expected changes won't be reflected in that stale Module object.

These autoloaded constants have been unloaded.

Please, check the "Autoloading and Reloading Constants" guide for solutions.
 (called from <main> at app/config/environment.rb:15)
 ```
