## 文法
### 変数のスコープ (scope)
- 変数がどこから参照できるかを定めた変数の有効範囲のこと
- グローバルスコープ
  - プログラムのどこからでも参照できる変数
  - JavaScriptにはグローバルオブジェクト(global object)と呼ばれるオブジェクトがたったひとつあり、ブラウザではwindowオブジェクトがグローバルオブジェクト
    - グローバル変数は、グローバルオブジェクトのプロパティ
    - 日付のDateクラスや、デバッグに使うconsoleオブジェクトなどの組み込みAPIはすべてwindowオブジェクトのプロパティ
    ```
    console
    => console {debug: ƒ, error: ƒ, info: ƒ, log: ƒ, warn: ƒ, …}
    window.console
    => console {debug: ƒ, error: ƒ, info: ƒ, log: ƒ, warn: ƒ, …}
    ```
- ローカルスコープ
  - 一定範囲にだけ効く変数スコープ
  - 関数スコープ(function scope)
    - 関数内でのみ参照できる範囲
    ```
    function func() {
      const variable = 123;
      return variable; // 参照できる
    }
    console.log(variable); // 参照できない
    ```
  - レキシカルスコープ(lexical scope)
    - 関数の外の変数
    ```
    const x = 100;
    function a() {
      console.log(x); // 関数の外の変数が見える
    }
    a();
    => 100
    ```
  - ブロックスコープ(block scope)
    - ブレース{ }で囲まれた範囲だけ有効
    ```
    {
      const x = 100;
      console.log(x);
    100
    }
    console.log(x); // xを参照できない
    ReferenceError: x is not defined
    
    if文でも同じ
    if (navigator.userAgent.includes("Firefox")) {
      const browser = "Firefox";
    } else {
      const browser = "Firefox以外";
    }
    console.log(browser); // 参照できずエラー
    ↓
    参照したい場合
    let browser;
    if (navigator.userAgent.includes("Firefox")) {
      browser = "Firefox";
    } else {
      browser = "Firefox以外";
    }
    console.log(browser); // OK
    ```

### if-else文
```
if (value === 0) {
  // ...
} else if (value === 1) {
  // ...
} else {
  // ...
}

// if文から直接変数への代入は出来ない
// こうした書き方はできない
// 代わりに三項演算子を使う
const drink = if (age >= 20) "ビール" else "ジュース";
```
### 三項演算子
``
const result = value === 0 ? "OK" : "NG";

条件のネスト
const extension = "ts";
const language =
  extension === "js"
    ? "JavaScript"
    : extension === "ts"
    ? "TypeScript"
    : extension === "java"
    ? "Java"
    : "不明";
```

### for-of文 - 拡張for文
```
for (変数 of 配列) {
  文;
}

const numbers = [1, 2, 3];
for (const n of numbers) {
  console.log(n);
}
=> 1 
=> 2 
=> 3

indexの取得する場合はentriesメソッドを組み合わせる
const words = ["I", "love", "TypeScript"];
for (const [index, word] of words.entries()) {
  console.log(index, word);
}
=> 0 I
=> 1 love
=> 2 TypeScript
```

### switch文
```
switch (条件) {
  case 値A:
    値Aの処理;
    break;
  case 値B:
    値Bの処理;
    break;
  default:
    値Aと値B以外の処理;
    break;
}
```
- switchは厳密等価演算
  - switch構文でその値であると判断されるのは等価演算(==)ではなく厳密等価演算(===)
  ```
  console.log(null == undefined);
  => true
  console.log(null === undefined);
  => false
  
  function test(n: unknown): void {
    switch (n) {
      case null:
        console.log("THIS IS null");
        return;
      case undefined:
        console.log("THIS IS undefined");
        return;
      default:
        console.log("THIS IS THE OTHER");
    }
  }

  test(null);
  => 'THIS IS null'
  test(undefined);
  => 'THIS IS undefined'
  ```
- フォールスルー問題(fallthrough)
  - switchのcaseには、分岐を抜けさせる働きがない
  - 分岐を抜けるには、breakが必要、breakを書かない場合、次の分岐も実行される
  - TypeScriptでは、コンパイラオプションnoFallthroughCasesInSwitchをtrueにすると、フォールスルーを警告するようになる
  ```
  let s = "A";
  switch (s) {
    case "A": // breakが無い分岐
      console.log(1);
    case "B": // この分岐にも処理が続く
      console.log(2);
  }
  1 2 の順で出力される
  
  ↓
  
  let s = "A";
  switch (s) {
    case "A":
  Fallthrough case in switch.
      console.log(1);
    case "B":
      console.log(2);
  }
  ```






