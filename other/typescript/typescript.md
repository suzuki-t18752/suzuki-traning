# typescriptのあれこれ

## 特徴
- JavaScriptの上位互換
  - TypeScriptはJavaScriptに型が追加され、それ以外の部分は基本的に互換性があります。
  - ECMAScriptの言語使用に対応している
- 古いJavascript環境にも対応できる
  - コンパイル時にバージョンを指定出来る
  - 古いものならES3
- 静的型付け言語
- フロントエンドはもちろん、node.jsを使うことでバックエンドにも対応できる

- 開発出来るもの
  - デスクトップアプリケーション
    - WindowsやmacOS、Linux向けにデスクトップアプリケーションを作れる
    - javaScript、HTML、CSSの技術スタックで開発できるElectronを使う
  - CLIアプリケーション
    - コマンドラインツールの開発
    - サーバーサイドJavaScript実行環境のNode.jsとTypeScriptを組み合わせて開発
    - CLIアプリケーションフレームワークには、Heroku製のoclif
      - Google製のzxを用いると、シェルスクリプトの代わりにTypeScriptを使う
  - ブラウザ拡張
  - 機械学習
    - TensorFlow.jsはGoogleが開発した機械学習ライブラリ
    - Brain.jsはニューラルネットワークのライブラリ
  - 組み込み系

## 予備知識
- ECMAScriptは
  - javascriptを標準化するためのもの
  - 言語の文法、構文の解釈方法、コアのAPIなど言語の中核部分
    - 関数宣言の書き方はこういう文法になる
    - 変数が宣言されたとき、JavaScriptエンジンはこういう動作
    - StringやArrayオブジェクトにはこういうメソッドがある
- HTML Living Standard
  - JavaScriptのブラウザ仕様
  - windowオブジェクトやHTMLDivElement、ローカルストレージなどのAPI
- JavaScriptエンジン
  - ECMAScriptを実装したモジュール
- レンダリングエンジン
  - JavaScriptエンジンを組み込んだブラウザの表示機能を担うモジュール
  - JavaScriptだけでなく、HTMLやCSSを解釈し、画面描画を総合的に行う
- ブラウザは、レンダリングエンジンを組み込み、その他にブックマーク機能などの付属機能をつけてアプリケーションというかたちでユーザーに提供する
  ```
  ブラウザ          | レンダリングエンジン | javascriptエンジン | 言語仕様
  Chrome           | Blink               | V8                 | ECMAScript
  Edge             |                     |                    |
  Opera            |                     |                    |
  ------------------------------------------------------------
  Firefox          | Gecko               | spiderMonkey       |
  ------------------------------------------------------------
  safari           | Webkit              | JavascriptCore     |
  Chrome for ios   |                     |                    |
  Edge for ios     |                     |                    |
  Opera for ios    |                     |                    |
  Fire fox for ios |                     |                    |
  ```

## import、export、require
- JavaScriptのファイルは大きく分けて、スクリプトとモジュールに分類される
  - スクリプト
    - 通常のjavascriptファイルのこと
    ```
    const foo = "foo";
    ```
  - モジュール
    - importまたはexportを1つ以上含むJavaScriptファイル
    - importは他のモジュールから変数、関数、クラスなどインポートするキーワード
      - importの読み込みは最初の1回だけ
      - 何度同じファイルをimportしても1回目が評価されたタイミングでファイルがキャッシュされ、2回目以降に流用される
    - exportは他のモジュールに変数、関数、クラスなどを公開するためのキーワード
    ```
    export const foo = "foo";
    ```

## 環境の準備
- Home brewのインストール
  - MacOS でおなじみのパッケージ管理ツール
```
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
 
 上記コマンド入力後下記表示が出るのでエンターキーを押下
 Press RETURN/ENTER to continue or any other key to abort:
 
 
 終了
 From https://github.com/Homebrew/homebrew-core
 * [new branch]      master     -> origin/master
HEAD is now at 79d5c2381ae libxcursor: update 1.2.1 bottle.
==> Downloading https://ghcr.io/v2/homebrew/portable-ruby/portable-ruby/blobs/sha256:fc45ee6eddf4c7a17f4373dde7b1bc8a58255ea61e6847d3bf895225b28d072a
######################################################################## 100.0%
==> Pouring portable-ruby-2.6.8_1.x86_64_linux.bottle.tar.gz
Warning: /home/linuxbrew/.linuxbrew/bin is not in your PATH.
  Instructions on how to configure your shell for Homebrew
  can be found in the 'Next steps' section below.
==> Installation successful!

==> Homebrew has enabled anonymous aggregate formulae and cask analytics.
Read the analytics documentation (and how to opt-out) here:
  https://docs.brew.sh/Analytics
No analytics data has been sent yet (nor will any be during this install run).

==> Homebrew is run entirely by unpaid volunteers. Please consider donating:
  https://github.com/Homebrew/brew#donations

==> Next steps:
- Run these three commands in your terminal to add Homebrew to your PATH:
    echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/suzuki_t18752/.profile
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/suzuki_t18752/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
- Install Homebrew's dependencies if you have sudo access:
    sudo apt-get install build-essential
  For more information, see:
    https://docs.brew.sh/Homebrew-on-Linux
- We recommend that you install GCC:
    brew install gcc
- Run brew help to get started
- Further documentation:
    https://docs.brew.sh


上記Next steps:に書かれた部分を実行する
suzuki_t18752@DESKTOP-HR1248R:~$ echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/suzuki_t18752/.profile
suzuki_t18752@DESKTOP-HR1248R:~$ echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/suzuki_t18752/.profile
suzuki_t18752@DESKTOP-HR1248R:~$ eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
suzuki_t18752@DESKTOP-HR1248R:~$ sudo apt-get install build-essential
Reading package lists... Done
Building dependency tree
Reading state information... Done
build-essential is already the newest version (12.8ubuntu1.1).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.


確認
suzuki_t18752@DESKTOP-HR1248R:~$ brew help
Example usage:
  brew search TEXT|/REGEX/
  brew info [FORMULA|CASK...]
  brew install FORMULA|CASK...
  brew update
  brew upgrade [FORMULA|CASK...]
  brew uninstall FORMULA|CASK...
  brew list [FORMULA|CASK...]

Troubleshooting:
  brew config
  brew doctor
  brew install --verbose --debug FORMULA|CASK

Contributing:
  brew create URL [--no-fetch]
  brew edit [FORMULA|CASK...]

Further help:
  brew commands
  brew help [COMMAND]
  man brew
  https://docs.brew.sh
suzuki_t18752@DESKTOP-HR1248R:~$ brew --version
Homebrew 3.6.6
Homebrew/homebrew-core (git revision 79d5c2381ae; last commit 2022-10-24)
```

- Node.jsのインストール
```

```

 

