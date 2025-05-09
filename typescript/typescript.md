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

- オブジェクトリテラル (object literal)
  - オブジェクトリテラル{}という記法を用いて、簡単にオブジェクトを生成できる
  ```
  // 空っぽのオブジェクトを生成
  const object = {};

  // プロパティを指定しながらオブジェクトを生成
  const person = { name: "Bob", age: 25 };
  ```
  - Objectをnewすることでオブジェクトを生成
  ```
  const person = new Object();
  person.name = "Bob";
  person.age = 25;
  ```
  - JavaScriptではJSONをそのままオブジェクトリテラルとして解釈出来る

- オブジェクトのプロパティ
  - オブジェクトは、プロパティの集合体でキーと値の対になっている
  ```
  const product = {
    name: "ミネラルウォーター",
    price: 100,
    getTaxIncludedPrice: function () {
      return Math.floor(this.price * 1.1);
    },
    shomikigen: new Date("2022-01-20"),
  };
  ```

- オブジェクトの型注釈 (type annotation)
```
let box: { width: number; height: number };
//       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^型注釈
box = { width: 1080, height: 720 };
```
  - プロパティの区切り文字には、オブジェクトリテラルのようにカンマ「,」も使えるが、セミコロン「;」を用いるほうを推奨される
    - 理由は、コード整形ツールPrettierがオブジェクト型注釈を直すとき、カンマをセミコロンに置き換えるため
    ```
    let box: { // 型宣言時はセミコロン
      width: number;
      height: number;
    };
    box = { width: 1080, height: 720 };
    ```
  - メソッドの型注釈
    - 引数と戻り値の型注釈
    ```
    let calculator: {
      sum(x: number, y: number): number;
    };

    calculator = {
      sum(x, y) {
        return x + y;
      },
    };
    ```
- オブジェクトの型推論
  - オブジェクトの値を変数宣言で代入する場合、型注釈を省略でき、値から型が自動的に判別される
  ```
  let box = { width: 1080, height: 720 };
       ↑
    let box: {
        width: number;
        height: number;
    }
   ```
- `Record<Keys, Type>`
  - 連想配列のようなキーバリューのオブジェクト型を定義する場合この方法もある
  ```
  let foo: Record<string, number>;
  foo = { a: 1, b: 2 };
  ```
- object型
  - オブジェクトの型注釈にはobject型を用いることもできる
  ```
  let box: object;
  box = { width: 1080, height: 720 };
  ```
  - しかし推奨されない
    - object型には何のプロパティがあるかの情報がないため
    ```
    参照するとコンパイルエラーになる
    box.width;
    Property 'width' does not exist on type 'object'.
    ```
    - 第2の理由はどんなオブジェクトでも代入でき、期待しない値も代入できてしまうから
    ```
    let box: object;
    box = { wtdih: 1080, hihget: 720 }; // スペルミス
    ```

- readonlyプロパティ
  - TypeScriptでは、オブジェクトのプロパティを読み取り専用にすることができる
    - 読み取り専用にしたいプロパティにはreadonly修飾子をつける
    - 読み取り専用のプロパティに値を代入しようとすると、TypeScriptコンパイラーが代入不可の旨を警告する
    ```
    let obj: {
      readonly foo: number;
    };
    obj = { foo: 1 };
    obj.foo = 2;
    Cannot assign to 'foo' because it is a read-only property.
    ```
  - readonlyは再帰的ではない
    - プロパティが読み取り専用になるだけでオブジェクトまでは読み取り専用にはならない
    ```
    let obj: {
      readonly foo: {
        bar: number;
      };
    };
    obj = {
      foo: {
        bar: 1,
      },
    };
    obj.foo = { bar: 2 };
    Cannot assign to 'foo' because it is a read-only property.
    obj.foo.bar = 2; // コンパイルエラーにはならない
    ```
    - 再帰的にプロパティを読み取り専用にしたい場合は、子や孫の各プロパティにreadonlyをつけていく必要がある
    ```
    let obj: {
      readonly foo: {
        readonly bar: number;
      };
    };
    ```
  - readonlyはコンパイル時のみ
    - readonlyはTypeScriptの型の世界だけの概念なのでコンパイルされた後のJavaScriptとしては、readonlyがついていたプロパティも代入可能になる
  - すべてのプロパティを一括して読み取り専用にする方法
    - ユーティリティ型のReadonlyを使う
    ```
    let obj: Readonly<{
      a: number;
      b: number;
      c: number;
      d: number;
      e: number;
      f: number;
    }>;
    ```
- readonlyとconstの違い
  - constは変数への代入を禁止にするもの
    - constの代入禁止が効くのは変数そのものへの代入だけ、変数がオブジェクトだった場合、プロパティへの代入は許可される
    ```
    const x = { y: 1 };
    x = { y: 2 }; // 変数そのものへの代入は不可
    Cannot assign to 'x' because it is a constant.
    x.y = 2; // プロパティへの代入は許可
    ```
  - readonlyはプロパティへの代入を禁止にするもの
    - readonlyがついたプロパティxに値を代入しようとすると、コンパイルエラーになるが、変数自体への代入は許可される
    ```
    let obj: { readonly x: number } = { x: 1 };
    obj.x = 2;
    Cannot assign to 'x' because it is a read-only property.
    let obj: { readonly x: number } = { x: 1 };
    obj = { x: 2 }; // 許可される
    ```
    
- オブジェクト型のオプションプロパティ (optional property)
  - オブジェクトプロパティのオプショナルを型付けするには、プロパティ名の後ろに`?`を書く
  ```
  let size: { width?: number };
  //オプションプロパティを持ったオブジェクト型には、そのオプションプロパティを持たないオブジェクトを代入できる
  size = {}; // OK
  //また、オプションプロパティの値がundefinedのオブジェクトも代入可能
  size = { width: undefined }; // OK
  //しかし、オプションプロパティの値がnullの場合は代入できない
  size = { width: null };
  Type 'null' is not assignable to type 'number | undefined'.
  ```
  
- 余剰プロパティチェック (excess property checking)
  - TypeScriptのオブジェクト型には余剰プロパティチェックという追加のチェックが働く場合がある
    - オブジェクト型に存在しないプロパティを持つオブジェクトの代入を禁止する検査
    ```
    let onlyX: { x: number };
    onlyX = { x: 1 }; // OK
    onlyX = { x: 1, y: 2 }; // コンパイルエラー
    Type '{ x: number; y: number; }' is not assignable to type '{ x: number; }'.
      Object literal may only specify known properties, and 'y' does not exist in type '{ x: number; }'.
    ```
 
- インデックス型 (index signature)
  - オブジェクトのフィールド名をあえて指定せず、プロパティのみを指定したい場合に使う
  ```
  let obj: {
    [K: string]: number;
  };
  ```
  - フィールド名の表現部分が[K: string]、このKの部分は型変数(Kやkeyにするのが一般的)
  - stringの部分はフィールド名の型、インデックス型のフィールド名の型はstring、number、symbolのみが指定可能
  ```
  let a: { b: number}
  a = {b: 1, c: 2} //NG
  let d: { [K: number]: number; }
  d =  {1: 2, 3: 2} //OK
  ```

- object型、Object型、{}型の違い
  - object型
    - object型はオブジェクト型の値だけが代入できる型、プリミティブ型が代入できない型
    ```
    let a: object;
    a = { x: 1 }; // OK
    a = [1, 2, 3]; // OK。配列はオブジェクト
    a = /a-z/; // OK。正規表現はオブジェクト

    // プリミティブ型はNG
    a = 1;
    => Type 'number' is not assignable to type 'object'.
    a = true;
    => Type 'boolean' is not assignable to type 'object'.
    a = "string";
    => Type 'string' is not assignable to type 'object'.
    ```
  - Object型
    - Object型はインターフェース
      - nullやundefinedを除くあらゆるプリミティブ型も代入できる
      ```
      let a: Object;
      a = {}; // OK

      // ボックス化可能なプリミティブ型OK
      a = 1; // OK
      a = true; // OK
      a = "string"; // OK

      // nullとundefinedはNG
      a = null;
      Type 'null' is not assignable to type 'Object'.
      a = undefined;
      Type 'undefined' is not assignable to type 'Object'.
      ```
    - TypeScriptでは使うべきではない
      - 理由 `https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html#number-string-boolean-symbol-and-object`
      - プリミティブ型も代入できてしまうため
  - {}型
    - プロパティを持たないオブジェクトを表す型
    - Object型と似ていて、nullやundefinedを除くあらゆる型を代入可能

- オブジェクトの分割代入 (destructuring assignment)
  - 分割代入は、オブジェクトからプロパティを取り出す機能
    - 通常、オブジェクトからプロパティを取り出す場合は、プロパティアクセサーを使う
    ```
    const item = { price: 100 };
    const price = item.price; // プロパティアクセサー
    ```
    - 分割代入は、中カッコ{}に取り出したいプロパティを指定することで、プロパティ名と同じ名前の変数が作れる
    ```
    const item = { price: 100 };
    const { price } = item; // item.priceを取り出している
    
    // 複数を取り出す場合
    const obj = { a: 1, b: 2 };
    const { a, b } = obj;
    
    // 代入する変数名の指定
    // オブジェクトの分割代入では、コロン:のあとに変数名を指定すると、その名前の変数に代入できる
    const color = { r: 0, g: 122, b: 204, a: 1 };
    const { r: red, g: green, b: blue, a: alpha } = color;
    console.log(green);
    => 122
    
    // 深い階層のプロパティを取り出すには、階層の分だけ中カッコで囲む
    const continent = {
      name: "北アメリカ",
      us: {
        name: "アメリカ合衆国",
        capitalCity: "ワシントンD.C.",
      },
    };
    
    //通常
    const {
      us: { name, capitalCity },
    } = continent;
    
    console.log(name);
    => "アメリカ合衆国"
    console.log(capitalCity);
    => "ワシントンD.C."
    
    // 変数名指定
    const {
      name: continentName,
      us: { name: countryName },
    } = continent;
    
    console.log(continentName);
    => "北アメリカ"
    console.log(countryName);
    => "アメリカ合衆国"
    ```
  - 分割代入のデフォルト値
    - 分割代入では、=のあとにデフォルト値が指定でき、デフォルト値は値がundefinedのときに代入される
    ```
    const color = { r: undefined, g: 122, b: 204 };
    const { r = 0, g = 0, b = 0 } = color;
    console.log(r, g, b);
    => 0,  122,  204
    
    // 値がnullのときは、デフォルト値が使われず、nullが入る
    const color = { r: null };
    const { r = 0 } = color;
    console.log(r);
    => null
    
    // デフォルト値と変数名の指定
    const color = { r: undefined, g: 122, b: 204 };
    const { r: red = 0 } = color;
    console.log(red);
    => 0
    ```
   
- オプショナルチェーン (optional chaining)
  - オプショナルチェーン`?.`は、オブジェクトのプロパティが存在しない場合でも、エラーを起こさずにプロパティを参照できる
  ```
  const book = undefined;
  const title = book.title;
  TypeError: Cannot read property 'title' of undefined
  
  const author = null;
  const email = author.email;
  TypeError: Cannot read property 'email' of null
  
  // エラーを避けるには、値がnullやundefinedでないかチェックする必要がある
  const book = undefined;
  const title = book === null || book === undefined ? undefined : book.title;
  console.log(title);
  => undefined

  const book = { title: "サバイバルTypeScript" };
  const title = book === null || book === undefined ? undefined : book.title;
  console.log(title);
  => "サバイバルTypeScript"
  
  // オプショナルチェーン
  const book = undefined;
  const title = book?.title;
  //                ^^オプショナルチェーン
  console.log(title);
  => undefined

  const book = { title: "サバイバルTypeScript" };
  const title = book?.title;
  console.log(title);
  => "サバイバルTypeScript"
  
  //関数を呼ぶとき
  // 引数カッコの前に?.を書く
  const increment = undefined;
  const result = increment?.(1);
  console.log(result);
  => undefined

  const increment = (n) => n + 1;
  const result = increment?.(1);
  console.log(result);
  => 2
  
  // 配列要素を参照する時
  // カギカッコの前に?.を書く
  const books = undefined;
  const title = books?.[0];
  console.log(title);
  => undefined

  const books = ["サバイバルTypeScript"];
  const title = books?.[0];
  console.log(title);
  => "サバイバルTypeScript"
  ```
  - TypeScriptでの型
    - TypeScriptでオプショナルチェーンを使った場合、得られる値の型は、最後のプロパティの型とundefinedのユニオン型になる
  - コンパイルの結果
    - TypeScriptのコンパイラーオプションtargetがes2020以上のときは、オプショナルチェーンはそのままJavaScriptにコンパイルされる
    ```
    const title = book?.title;
    ```
    - targetがes2019以前の場合は、次のような三項演算子を用いたコードにコンパイルされる
    ```
    const title = book === null || book === void 0 ? void 0 : book.title;
    ```
  - Null合体演算子と組み合わせる
    - オプショナルチェーンがundefinedを返したときに、デフォルト値を代入したい場合があるが、Null合体演算子`??`を用いると便利
    ```
    const book = undefined;
    const title = book?.title ?? "デフォルトタイトル";
    console.log(title);
    => "デフォルトタイトル"
    ```
    
- オブジェクトをループする
  - for-in文
  ```
  const foo = { a: 1, b: 2, c: 3 };
  for (const prop in foo) {
    console.log(prop, foo[prop]);
    // a 1
    // b 2
    // c 3 の順で出力される
  }
  - for-in文ではhasOwnPropertyを使おう
    - Object.prototypeを変更するとその影響は、このプロトタイプを持つすべてのオブジェクトに影響
    ```
    const foo = { a: 1 };
    const date = new Date();
    const arr = [1, 2, 3];

    // どのオブジェクトもhiプロパティが無いことを確認
    console.log(foo.hi, date.hi, arr.hi);
    undefined undefined undefined

    // プロトタイプにプロパティを追加する
    Object.prototype.hi = "Hi!";

    // どのオブジェクトもhiプロパティを持つようになる
    console.log(foo.hi, date.hi, arr.hi);
    => Hi! Hi! Hi!

    // for-in文はプロトタイプのプロパティも含めてループする仕様がありプロトタイプが変更されると、意図しないところでfor-inのループ回数が変わることがある
    const foo = { a: 1, b: 2, c: 3 };
    Object.prototype.hi = "Hi!";
    for (const prop in foo) {
      console.log(prop, foo[prop]);
      // a 1
      // b 2
      // c 3
      // hi Hi! の順で出力される
    }

    // for-inで反復処理を書く場合は、hasOwnPropertyでプロパティがプロトタイプのものでないことをチェックしたほうが安全
    const foo = { a: 1, b: 2, c: 3 };
    Object.prototype.hi = "Hi!";
    for (const prop in foo) {
      if (Object.prototype.hasOwnProperty.call(foo, prop)) {
        console.log(prop, foo[prop]);
        // a 1
        // b 2
        // c 3  の順で出力される
      }
    }
    ```
  - Object.entries
    - for-in文と異なり、hasOwnPropertyのチェックが不要
    ```
    const foo = { a: 1, b: 2, c: 3 };
    for (const [key, value] of Object.entries(foo)) {
      console.log(key, value);
      // a 1
      // b 2
      // c 3 の順で出力される
    }
    ```
  - Object.keys
    - プロパティのキーだけを反復処理する場合
    ```
    const foo = { a: 1, b: 2, c: 3 };
    for (const key of Object.keys(foo)) {
      console.log(key);
      // a
      // b
      // c の順で出力される
    }
    ```
  - Object.values
    - プロパティの値だけを反復処理する場合
    ```
    const foo = { a: 1, b: 2, c: 3 };
    for (const value of Object.values(foo)) {
      console.log(value);
      // 1
      // 2
      // 3 の順で出力される
    }
    ```


### プロトタイプベース
- オブジェクト生成方法の1つ(javascriptで使われる)
  - 他にクラスベースがある(phpやjava)
    - オブジェクトの素となるものはクラスなのがクラスベース
- オブジェクトを素にして新しいオブジェクトを生成する
  - 「プロトタイプ」とは日本語では「原型」のことでプロトタイプベースは型となるオブジェクトを素にオブジェクトを生成するアプローチ
```
たとえば、JavaScriptでは既存のオブジェクトに対して、Object.create()を実行すると新しいオブジェクトが得られる
const button = {
  name: "ボタン",
};
 
const dangerousButton = Object.create(button);
dangerousButton.name = "絶対に押すなよ？";

上の例のbuttonとdangerousButtonは異なるオブジェクト
console.log(button.name);
=> "ボタン"
console.log(dangerousButton.name);
=> "絶対に押すなよ？"
```
- 継承
```
const counter = {
  count: 0,
  countUp() {
    this.count++;
  },
};
 
const resettableCounter = Object.create(counter);
resettableCounter.reset = function () {
  this.count = 0;
};
```

### 配列リテラル(array literal)
```
[1, 2, 3];
```
- 配列の型注釈(type annotation)
  - 2つの方法がある
    - `Type[]`
      - 1つ目の型注釈は、要素の型の後ろに`[]`をつける書き方
      ```
      let array: number[];
      array = [1, 2, 3];
      ```
    - `Array<T>`
      - Tには要素の型を書く
      ```
      let array: Array<number>;
      array = [1, 2, 3];
      ```
    - 2種類の違いは書き方がちがうだけ、コンパイラのチェックの内容はどちらも同じ
      - どちらの書き方を選ぶかは、書き手の好み、プロジェクトとしてはどちらの書き方にするか

- 配列はオブジェクト
  - JavaScriptの配列はオブジェクトであるため、配列の中身が同じでも、オブジェクトのインスタンスが異なると`==`では期待する比較ができない
  ```
  const list1 = [1, 2, 3];
  const list2 = [1, 2, 3];
  console.log(list1 == list2);
  => false
  ```
  - 配列の中身を比べるための演算子やメソッドはJavaScriptにはないため、中身を比較したいときにはlodashのisEqualなどのパッケージを使うと良い


- 配列要素へのアクセス
  - JavaScriptでの配列要素アクセス
    - 配列の要素にアクセスするにはブラケット`[]`を使う
    ```
    const abc = ["a", "b", "c"];
    console.log(abc[0]);
    => "a"
    ```
    - JavaScriptの配列では、存在しないインデックス番号でもアクセス可能
    ```
    const abc = ["a", "b", "c"];
    console.log(abc[100]);
    => undefined
    ```
  - Typescriptでは
    - `Type[]`型の配列から要素を取り出したとき、その値の型はTypeになる
    ```
    const abc: string[] = ["a", "b", "c"];
    const character: string = abc[0];
    ```
    - TypeScriptでも不在要素へのアクセスについて、コンパイラーが警告することはない
    ```
    const abc = ["a", "b", "c"];
    const character: string = abc[100]; // エラーにはならない
    => undefine
    ```
      - 要素アクセスで得た値はstringとundefinedどちらの可能性もありながら、TypeScriptは常にstring型であると考え、JavaScript実行時に判明する
      ```
      const abc = ["a", "b", "c"];
      const character: string = abc[100];
      console.log(character);
      undefined
      character.toUpperCase();
      Cannot read properties of undefined (reading 'toUpperCase')
      ```








