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
- 変数宣言の型推論(type inference)
  - 型推論は、コンパイラが型を自動で判別する機能
  ```
  let x = 1; // let x: number = 1;と同じ意味になる
  x = "hello";
  Type 'string' is not assignable to type 'number'.
  ```
  
### データ型 
- JavaScriptのデータ型は、プリミティブ型とオブジェクトの2つに分類される
- イミュータブル特性
  - 値を直接変更できないこと
  - 対比として値を後で変更できるというミュータブル特性(mutable)
- プロパティを持たない
  - プリミティブ型のnullとundefinedにはプロパティがない
  ```
  null.toString(); // エラーになる
  ```
  - 文字列や数値などのプリミティブ型は、プロパティを持ったオブジェクトとして扱える
  ```
  "name".length; // 4
  ```
  - プリミティブ型をまるでオブジェクトのように扱えるのはJavaScriptの特徴
    - オートボクシング(autoboxing)
      - プリミティブ型をオブジェクトに自動変換する機能
#### プリミティブ型 (primitive types)
- 論理型 (boolean type)
  - trueとfalseの論理値からなる型
  ```
  const isOk = true;
  const isPanda = false;
  型注釈
  const isOk: boolean = true;
  ```
- 数値型 (number type)
  - 1や-1などの整数と0.1などの小数を含めた数値の型
  ```
  123 // 整数
  -123 // 整数(負の数)
  20.315 // 小数

  小数は小数点ではじめる書き方もできる
  0.1 === .1
  5.0 === 5.
  ```
  - 2進数、8進数、16進数
  ```
  0b1010 // 2進数
  0o755 // 8進数
  0xfff // 16進数
  ```
  - アンダースコアで区切って書ける
  ```
  100_000_000 // 1億
  NG
  _100
  100_
  100_.0
  100._0
  1__00
  ```
  - 小数点とドットが区別できない為、下記のような書き方はNG
    - 回避するには、ドットを2つ続けるか、数値をカッコで囲む
  ```
  5.toString(); // この書き方は構文エラー
  An identifier or keyword cannot immediately follow a numeric literal.
  
  5..toString();
  (5).toString();
  ```
  - 数値型の型注釈はnumber
  ```
  const count: number = 123;
  ```
  - 数値の範囲
    - IEEE 754の倍精度浮動小数
      - 64ビットのうち、52ビットが数値の格納に、11ビットが小数の位置に、1ビットが正負符号
      - 正確に扱える数値は-(2^53 − 1)から2^53 − 1の間
  - 特殊な数値
    - 数値型には、NaNとInfinityという特殊な値がある
    - NaN
      - NaNは非数(not-a-number)を表す変数
      - 処理の結果、数値にならない場合にNaNを返す
      ```
      const price = parseInt("百円");
      console.log(price);
      => NaN
      
      Nunmber.isNaN(price)
      上記でNaNかチェック出来る
      ```
      - NaNは特殊で、等号比較では常にfalseになる
      ```
      console.log(NaN == NaN);
      => false
      console.log(NaN === NaN);
      => false
      ```
    - Infinity
      - 無限大を表す変数
      ```
      1 / 0
      => Infinity
      ```
  - 小数計算の誤差
    - 小数の計算には誤差が生じる場合がある
      - IEEE 754という規格の制約
    ```
    10進数の0.2は有限小数ですが、それを2進数で表すと0.0011...のような循環小数になる
    循環小数は小数点以下が無限に続きますが、IEEE 754が扱う小数点以下は有限であるため、循環小数は桁の途中で切り捨てられる
    その結果、小数の計算に誤差が生じてしまう
    0.1 + 0.2
    => 0.30000000000000004
    
    2進数で有限小数になる0.5や0.25などの数値だけを扱う計算は誤差なく計算できる
    0.5 + 0.25 === 0.75; //=> true

    小数計算の誤差を解決するために、一度整数に桁上げして計算し、もとの桁を下げる方法がある
    110 * 1.1; //=> 121.00000000000001
    (110 * 11) / 10 === 121; //=> true
    ```  

- 文字列型 (string type)
  - 他の言語と違いシングルクォートとダブルクフォートで違いがない
  ```
  "Hello"; 
  'Hello'; 
  `Hello`;
  ```
  - 同じ引用符が含まれている場合は、バックスラッシュ\でエスケープする
  ```
  'He said "madam, I\'m Adam."'
  "He said \"madam, I'm Adam.\""
  
  シングルクォートでも\nで改行出来る(rubyはダブルクフォートのみ)
  ```
  - テンプレートリテラル
    - バッククォート`で囲んだ文字列
    - 改行と式の挿入(expression interpolation)ができる
    ```
    const count = 10;
    console.log(`現在、${count}名が見ています。`);
    => 現在、10名が見ています。
    
    `te
    st`
    => 'te\nst'
    'te
    st'  
    VM844:1 Uncaught SyntaxError: Invalid or unexpected token
    ```
  - クフォートの使用基準
    1. 基本的に"を使用する
    2. 文字列の中に"が含まれる場合は'を使用する
    3. 文字列展開する必要があるときは`を使用する
  - 型注釈
  ```
  const message: string = "Hello";
  ```
  - 文字列結合
  ```
  "hello" + "world"
  ```

- null型
  - nullは値がないことを示す値
  ```
  const x = null;
  ```
  - 型注釈
  ```
  const x: null = null;
  ```
  - nullに対してtypeofを用いると"object"が返るので注意
  ```
  typeof null
  => 'object'
  typeof 1
  => 'number'
  typeof [1,2]
  => 'object'
  typeof 'te'
  => 'string'
  ```

- undefined型
  - 未定義を表す
  - 変数に値がセットされていないとき、戻り値が無い関数、オブジェクトに存在しないプロパティにアクセスしたとき、配列に存在しないインデックスでアクセスしたときなど
  ```
  let name;
  console.log(name);
  => undefined

  function func() {}
  console.log(func());
  => undefined

  const obj = {};
  console.log(obj.name);
  => undefined

  const arr = [];
  console.log(arr[1]);
  => undefined
  ```
  - undefinedにはリテラルがない
  - undefinedは変数
  - 型注釈
  ```
  const x: undefined = undefined;
  ```
    - TypeScriptで戻り値なしを型注釈で表現する場合、undefinedではなくvoidを用いる

- シンボル型 (symbol type)
  - その値が一意になる値
  - 論理型や数値型は値が同じであれば、等価比較がtrueになるが、シンボルはシンボル名が同じであっても、初期化した場所が違うとfalseになる
  ```
  const s1 = Symbol("foo");
  const s2 = Symbol("foo");
  console.log(s1 === s1);
  => true
  console.log(s1 === s2);
  => false
  ```
  - 型注釈
  ```
  const s: symbol = Symbol();
  ```
  - シンボルの用途
    - JavaScriptの組み込みAPIの下位互換性を壊さずに新たなAPIを追加すること
      - JavaScript本体をアップデートしやすくするために導入されたもの
      - なのでシンボル型を使ってコードを書くことはそうそうない

- bigint型
  - 数値型よりも大きな整数を扱える
  - bigint型のリテラルは整数値の末尾にnをつけて書
  ```
  const x = 100n;
  ```
  - 型注釈
  ```
  const x: bigint = 100n;
  ```
  - BigInt関数
    - bigint型はBigInt関数を使って作ることができ、BigInt関数は第1引数に数値もしくは文字列を渡す
  ```
  const x = BigInt(100);
  const y = BigInt("9007199254740991");
  ```
  - bigint型を数値型と計算する
    - bigint型と数値型はそのままでは一緒に演算をすることはできない
    - どちらかに型を合わせる必要がある
  ```
  2n + 3;
  Operator '+' cannot be applied to types '2n' and '3'.
  
  const i = 2n + BigInt(3); //=> 5n
  console.log(i);
  => 5
  ```

### ボックス化 (boxing)
- プリミティブからオブジェクトへの変換のこと
  - 多くの言語では、プリミティブは一般的にフィールドやメソッドを持たない
    - プリミティブをオブジェクトのように扱うには、プリミティブをオブジェクトに変換する必要がある
- 自動ボックス化
  - JavaScriptでは、プリミティブ型の値でもフィールドを参照できたり、メソッドが呼び出せる
  ```
  const str = "abc";
  // オブジェクトのように扱う
  str.length; // フィールドの参照
  str.toUpperCase(); // メソッド呼び出し
  
  プリミティブ型の値はオブジェクトではないため、このような操作ができずボックス化する必要があるはずだが、Javascriptでは内部的にプリミティブ型をオブジェクトに変換している
  ```
- ラッパーオブジェクト(wrapper object)
  - JavaScriptの自動ボックス化で変換先となるオブジェクトのこと
  ```
  プリミティブ型 |	ラッパーオブジェクト
  boolean       |	Boolean
  number	      | Number
  string	      | String
  symbol	      | Symbol
  bigint	      | BigInt
  ```
  - プリミティブ型のundefinedとnullにはラッパーオブジェクトがない
    - なのでメソッドやフィールドの参照は常にエラーが発生
    ```
    null.toString();
    Object is possibly 'null'.
    
    undefined.toString();
    Object is possibly 'undefined'
    ```
- 型について
  - 値型
    - プリミティブ型
      - bool型やint型、double型などの最も基本的な型
  - 参照型
    - オブジェクト型
  - 値型と参照型の違い
    - メモリへの保存方法
      - 値型は、変数が用意する「入れ物」に直接データを保存する
        - 変数に値を代入すると、確保された領域に実際のデータが保存される
      - 参照型は、変数が用意する「入れ物」には実際のデータは保存しない
        - 変数の「入れ物」には、実際のデータを保存する「別の保存領域」の場所を示すアドレスが保存される

- リテラル型 (literal type)
  - プリミティブ型の特定の値だけを代入可能にする型
  ```
  let x: 1;
  x = 1;
  x = 100;
  Type '100' is not assignable to type '1'.
  
  論理型のtrueとfalse
  数値型の値
  文字列型の文字列
  const isTrue: true = true;
  const num: 123 = 123;
  const str: "foo" = "foo";
  ```
  - 一般的にリテラル型はマジックナンバーやステートの表現に用いられる
  ```
  let num: 1 | 2 | 3 = 1;
  ```

- any型
  - どんな型でも代入を許す型
  - プリミティブ型であれオブジェクトであれ何を代入してもエラーにならない
  - 暗黙のany
    - 型を省略してコンテキストから型が推論できない時、TypeScriptは暗黙的に型をany型として扱う
    ```
    name 変数がany型として判定されるため、型チェックは問題なく通っているが、number型の値で toUpperCase() のメソッドの呼び出しが実行されるため、未定義メソッドとしてエラーが発生する
    function hello(name) {
                
    (parameter) name: any
      console.log(`Hello, ${name.toUpperCase()}`);
    }

    hello(1);
    name.toUpperCase is not a function
    ```
    - noImplicitAny
      - 上記のような状況を防止するため、暗黙のanyを規制するオプション
      - tsconfig.json にて noImplicitAny: true を設定することで、TypeScriptが型をany型と推測した場合にエラーが発生する

### オブジェクト
- プリミティブ型以外のものはすべてオブジェクト型
- プリミティブ型は値が同じであれば、同一のものと判定できますが、オブジェクト型はプロパティの値が同じであっても、インスタンスが異なると同一のものとは判定されない
```
const value1 = 123;
const value2 = 123;
console.log(value1 == value2);
=> true
 
const object1 = { value: 123 };
const object2 = { value: 123 };
console.log(object1 == object2);
=> false
```















  
