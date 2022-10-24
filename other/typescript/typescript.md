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
brew install node@16

実行結果
==> Installing node@16
==> Pouring node@16--16.18.0.x86_64_linux.bottle.tar.gz
==> Caveats
node@16 is keg-only, which means it was not symlinked into /home/linuxbrew/.linuxbrew,
because this is an alternate version of another formula.

If you need to have node@16 first in your PATH, run:
  echo 'export PATH="/home/linuxbrew/.linuxbrew/opt/node@16/bin:$PATH"' >> ~/.profile

For compilers to find node@16 you may need to set:
  export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/node@16/lib"
  export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/node@16/include"

==> Summary
🍺  /home/linuxbrew/.linuxbrew/Cellar/node@16/16.18.0: 1,918 files, 55.5MB
==> Running `brew cleanup node@16`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
==> Caveats
==> node@16
node@16 is keg-only, which means it was not symlinked into /home/linuxbrew/.linuxbrew,
because this is an alternate version of another formula.

If you need to have node@16 first in your PATH, run:
  echo 'export PATH="/home/linuxbrew/.linuxbrew/opt/node@16/bin:$PATH"' >> ~/.profile

For compilers to find node@16 you may need to set:
  export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/node@16/lib"
  export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/node@16/include"
  

上記に結果にある下記コマンドを実行
echo 'export PATH="/home/linuxbrew/.linuxbrew/opt/node@16/bin:$PATH"' >> ~/.profile

上記実行後確認
suzuki_t18752@DESKTOP-HR1248R:~$ node -v
v16.18.0
```

- TypeScriptをインストール
```
TypeScriptコンパイラをインストール
npm install -g typescript

suzuki_t18752@DESKTOP-HR1248R:~$ npm install -g typescript

added 1 package, and audited 2 packages in 899ms

found 0 vulnerabilities

インストールの確認
suzuki_t18752@DESKTOP-HR1248R:~$ tsc -v
Version 4.8.4
```


## いろいろ
- ファイルの実行
  - node ファイルのパス
  - ファイルを実行する
```
suzuki_t18752@DESKTOP-HR1248R:~/test_typescript$ node increment.js
1000
```
- 関数
```
incrementという関数を定義している
与えた引数numに1の数値を足した値を返す関数
function increment(num) {
  return num + 1;
}

実行結果
console.log(increment(999));
suzuki_t18752@DESKTOP-HR1248R:~/test_typescript$ node increment.js
1000
```

- 型強制
  - 型が異なる2つの値を処理するとき、暗黙的に別の型へ変換されること
```
increment関数に与える引数を数値から文字列に変えた場合
console.log(increment("999"));
suzuki_t18752@DESKTOP-HR1248R:~/test_typescript$ node increment.js
9991

上記のように文字列999に1が連結されたものが返る
```

- JavaScriptをTypeScriptに変換する
  - ファイルの拡張子を.jsから.tsに変更する

- コンパイラを働かせる
  - TypeScriptの目玉機能はコンパイラ
    - コンパイラの役割のひとつは、型の問題をチェックし、発見した問題点をプログラマに報告すること
    - TypeScriptコンパイラはとても賢く、ノーヒントでも型の問題を指摘してくれるがヒントを与えた方が緻密なチェックをしてくれる
    - コンパイラに与えるヒントのことを「型注釈(type annotation)」と言う
    ```
    incrementの引数に型注釈を行う
    function increment(num: number) {
    //                 ^^^^^^^^型注釈
      return num + 1;
    }
  - コンパイラでのチェック
    - tsc ファイルのパス
    ```
    数値型が入るはずなのに文字列型が入ってきていますよと警告が出ている
    suzuki_t18752@DESKTOP-HR1248R:~/test_typescript$ tsc increment.ts
    increment.ts:6:25 - error TS2345: Argument of type 'string' is not assignable to parameter of type 'number'.

    6   console.log(increment("999"));
                              ~~~~~
    Found 1 error in increment.ts:6
    
    修正すると
    console.log(increment(999));
    suzuki_t18752@DESKTOP-HR1248R:~/test_typescript$ tsc increment.ts
    エラーがでずに終了する
    ```
  - コンパイルした際に実際にブラウザで実行されるJavascriptファイルが生成される
    - TypeScriptコンパイラはJavaScript実行環境で動かす用のJavaScriptファイルを生成してくれ、開発者はこの成果物のJavaScriptファイルを本番環境にデプロイする


## 基礎
### 変数宣言
- let
  - 再代入が可能
  - letは変数の初期値なしで変数定義できます。初期値なしの変数の値はundefinedになる
```
let x = 1;
x = 2;

let x;//undefined
x = 1;
```
- const 
  - 初期値は必須
  - 変数への再代入が禁止
```
const y = 2;
y = 1;
TypeError: Assignment to constant variable.
```
  - constは可変(ミュータブル)オブジェクトを保護しない
    - constでオブジェクトを宣言した場合、変数自体への再代入はできないが、オブジェクトプロパティは変更できる
      - 連想配列のkeyは変更できないがattributeは変更できてしまう(rubyでいうところの)
    ```
    const obj = { a: 1 };
    obj = { a: 2 }; // 再代入は不可
    Cannot assign to 'obj' because it is a constant.
    obj.a = 2; // プロパティの変更はできる
    ```
    - オブジェクトを不変にするには、プロパティを読み取り専用にする必要がある(オブジェクト型のreadonlyプロパティを使う)
    - 配列もオブジェクトの一種なので変数自体の再代入はできないが、配列要素は変更できる
- var
  - 使わない、古い変数宣言の方法
  - 問題点
    - varの変数宣言では同じ変数名で宣言をした場合にエラーとならずに、後から宣言された変数が有効となってしまう
      - letとconstでは、同名の変数宣言はエラーになる
    - varでの変数巻き上げでは参照エラーとならないため、意図せずにundefinedの値を参照し予期せぬバグが発生する危険性がある
      - letとconstでは、宣言前の変数を参照するとReference Errorが発生する
- 変数の巻き上げ
  - JavaScriptで宣言された変数はスコープの先頭で変数が生成される

### 型注釈
- 変数宣言するときに、その変数にどんな値が代入可能かを指定すること
```
const num: number = 123;
```
