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
