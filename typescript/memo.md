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
