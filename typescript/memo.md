## react
- useState
  - 画面のリロードを行わずに一部の表示や値を変更できる
- useEffect
  - 何かの処理やが実行された際やページリロード時にに処理を実行させることが出来る
- useContext
  - データの受け渡しをわかりやすく行えるようにするもの
  - グローバル変数に近い
- useRef
  - 要素のいろいろなデータを取得できる
  - 要素のサイズ(height等)やvalue等いろいろ
## Typescript
- コールバック関数
  - 別の関数に渡される関数のこと
- Promise
  - 非同期処理のタイミングを制御出来るもの
  - これが出来る前はコールバック関数の中でさらにコールバック関数を呼ぶような読みにく処理になっていた
```
// 非同期でAPIにリクエストを投げて値を取得する処理
function request1(): Promise<number> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(1);
    }, 1000);
  });
}
 
// 受け取った値を別のAPIにリクエストを投げて値を取得する処理
function request2(result1: number): Promise<number> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(result1 + 1);
    }, 1000);
  });
}
 
// 受け取った値を別のAPIにリクエストを投げて値を取得する処理
function request3(result2: number): Promise<number> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(result2 + 2);
    }, 1000);
  });
}
 
request1()
  .then((result1) => {
    return request2(result1);
  })
  .then((result2) => {
    return request3(result2);
  })
  .then((result3) => {
    console.log(result3);
    // @log: 4
  });
```
- async/await
  - Promiseでの制御をより見やすく分かりやすく書くためのもの
```
関数の前にasyncキーワードをつけると、たとえその関数内でPromiseが返されていなくても、戻り値の型をPromiseで包んで返す
async function requestAsync(): Promise<number> {
  return 1;
}


Promiseをそのまま返すことも可能、二重にPromiseがラップされることはない
async function requestAsync(): Promise<number> {
  return new Promise((resolve) => {
    resolve(1);
  });
}
 
requestAsync().then((result) => {
  console.log(result);
  // @log: 1
});
```
```
awaitはPromiseの値が解決されるまで実行を待機して、解決された値を返す
awaitの注意点として**awaitはasync関数の中でのみ使える
// 1秒後に値を返す
function request(): Promise<string> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve("hello");
    }, 1000);
  });
}
 
// この書き方はできない
// const result = await request();
// console.log(result);
 
async function main() {
  const result = await request();
  console.log(result);
  // @log: "hello"
}
 
main();
```

```
// 非同期でAPIにリクエストを投げて値を取得する処理
function request1(): Promise<number> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(1);
    }, 1000);
  });
}
 
// 受け取った値を別のAPIにリクエストを投げて値を取得する処理
function request2(result1: number): Promise<number> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(result1 + 1);
    }, 1000);
  });
}
 
// 受け取った値を別のAPIにリクエストを投げて値を取得する処理
function request3(result2: number): Promise<number> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(result2 + 2);
    }, 1000);
  });
}
 
async function main() {
  const result1 = await request1();
  const result2 = await request2(result1);
  const result3 = await request3(result2);
  console.log(result3);
  // @log: 4
}
 
main();
```
## tsconfig
- typescriptの設定ファイル
- 項目
  - target
    - どのバージョンのjavascriptにコンパイルするのか？

    | バージョン | 指定する値| 利用可能なAPI例 |
    | ---- | ---- | ---- |
    | Node 8 | ES2017 | Object.entries、Object.values、date.formatToParts |
    | Node 10 | ES2018 | async iterables、promise.finally、rexexp.groups |
    | Node 12 | ES2019 | array.flat、array.flatMap、string.trimStart |
    | Node 14 | ES2020 | string.matchAll |
    | Node 16 | ES2021 | string.replaceAll |

  - lib
    - 組み込みライブラリの設定
    - libを指定する際は必ず先頭にtargetと同じものを指定する
    - NG
      ```
      {
        "compilerOptions": {
          "target": "es2018"
          // "lib": []
        }
      }
      ```
    - OK
      ```
      {
        "compilerOptions": {
          "target": "es2018",
          "lib": [
            "es2018",
            "esnext.AsyncIterable",
            "esnext.Array",
            "esnext.Intl",
            "esnext.Symbol"
          ]
        }
      }
      ```
  - module
    - モジュールの読み込み方を指定する
    - commonjs
      - バックエンド(サーバーサイド)で使われているモジュールの読み込み方法
    - es2015, es2020, esnext、、、etc
      - 通称esmoduleと呼ばれ、フロントエンドで使われるモジュール読み込みの解決方法
  - types
    - デフォルトでは、すべての表示されている@typesパッケージがコンパイル時にインクルードされる
    - typesを設定すると、リストに列挙したパッケージのみがインクルードされる
    ```
    例
    {
      "compilerOptions": {
        "types": ["node", "lodash", "express"]
      }
    }
    ```
  - outDir
    - コンパイル結果の出力先ディレクトリ
    - 未指定だとtsファイルと同ディレクトリに出力される
  - outFile
    - コンパイル結果を一つのファイルにまとめる（true/false）
    - outFileを指定した場合はoutDirオプションは無視される
  - rootDir
    - コンパイル対象のソースコードが含まれるルートディレクトリ
  - baseUrl
    - 絶対パス指定じゃない場合、どこを基準のフォルダにするのか
  - removeComments
    - TS→JS変換時にコメントを削除する(true/false)
    - デフォルトはfalse
  - preserveConstEnums
    - const enum定義をJSコンパイル時に消すか残すか（true/false)
```
例
{
  "compilerOptions": {
    "target": "es2020",
    "module": "esnext",
    "lib": ["es2020", "dom"],
    "jsx": "react",
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "moduleResolution": "node",
    "baseUrl": "src",
    "esModuleInterop": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["dist", "node_modules"],
  "compileOnSave": false
}
```

## webpack
  - モージュールバンドラ
    - 複数のファイルを１つにまとめて出力してくれるツールのこと
    - 複数ファイルをまとめることを「バンドル」と呼ぶ
  - なぜ使うのか？
    - 複数のjsファイルを読み込もうとするとjsファイルの数分リクエストが発生し、読み込むのに時間がかかる
    - webpackで１つのファイルにまとめることで読み込みを早くし、性能を高めることが出来る
  - ビルドの流れ
    1. tsファイルをtypescriptの機能でコンパイルしてjsファイルに変換する
    2. jsファイルをwebpackの機能でbundle.jsという1つのファイルにまとめる
