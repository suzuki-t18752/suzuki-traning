# typescriptのあれこれ

## 特徴
- JavaScriptの上位互換
  - TypeScriptはJavaScriptに型が追加され、それ以外の部分は基本的に互換性があります。


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
