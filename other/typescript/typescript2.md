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
```
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
- switchと変数スコープ
```
switchごとに変数スコープが作られる
switch (
  true // 変数スコープその1
) {
  default:
    switch (
      true // 変数スコープその2
    ) {
      default:
      // ...
    }
}


caseの変数スコープはない、複数のcaseがある場合、switch全体で変数スコープを共有
複数のcaseで同じ変数名を宣言すると実行時エラーが発生
let x = 1;
switch (x) {
  case 1:
    const sameName = "A";
    break;
  case 2:
    const sameName = "B";
SyntaxError: Identifier 'sameName' has already been declared
    break;
}

TypeScriptでは、同じ変数名を宣言するとコンパイルエラー
let x = 1;
switch (x) {
  case 1:
    const sameName = "A";
Cannot redeclare block-scoped variable 'sameName'.
    break;
  case 2:
    const sameName = "B";
Cannot redeclare block-scoped variable 'sameName'.
    break;
}

caseに変数スコープを作る方法
中カッコでcase節を囲む
let x = 1;
switch (x) {
  case 1: {
    const sameName = "A";
    break;
  }
  case 2: {
    const sameName = "B";
    break;
  }
}
```

### 例外処理(exception)
- 例外にはErrorオブジェクトを使い、throw構文で例外を投げ、try-catch構文で例外を捕捉する
```
try {
  throw new Error("something wrong");
} catch (e) {
  // something wrong
  console.log(e.message);
}

throw構文
throw new Error("something wrong");
=> Uncaught Error: something wrong at <anonymous>:1:7
  
catchの型
catchの変数の型はデフォルトでany型
TypeScriptのコンパイラーオプションのuseUnknownInCatchVariablesを有効にすると、
catchの変数の型がunknown型になり、「どんな値がthrowされるか分からない」ことを型として正確に表現できる
  
catchの分岐
JavaScriptでエラーの型によってエラーハンドリングを分岐したい場合は、catchブロックの中で分岐を書く
try {
  // ...
} catch (e) {
  if (e instanceof TypeError) {
    // TypeErrorに対する処理
  } else if (e instanceof RangeError) {
    // RangeErrorに対する処理
  } else if (e instanceof EvalError) {
    // EvalErrorに対する処理
  } else {
    // その他のエラー
  }
}
  
try-catchはブロックスコープ
try-catch文内の変数はブロックスコープになり宣言された変数は、try-catchの外では参照できない
  
async function fetchData() {
  try {
    const res = await fetch("https://jsonplaceholder.typicode.com/todos/1");
    const data = await res.json();
    console.log(data); // dataが参照できる
  } catch (e: unknown) {
    return;
  }
  console.log(data); // dataが参照できない
Cannot find name 'data'.
}
 
try-catch文の外でも変数を参照したい場合は、tryの前に代入用の変数をlet宣言しておく
async function fetchData() {
  let data: any;
  try {
    const res = await fetch("https://jsonplaceholder.typicode.com/todos/1");
    data = await res.json();
  } catch (e: unknown) {
    return;
  }
  console.log(data); // dataが参照できる
}
  
finallyブロック
finallyは例外が発生しようがしまいが必ず実行される処理
try {
  // ...
} catch (e) {
  // ...
} finally {
  // ...
}
```

## 関数
- 基本
```
function hello() {
  return "hello";
}
```
- 型注釈方法
```
//num:の後ろが引数の型注釈
//increment(num: number):の後ろが返り値の型注釈
function increment(num: number): number {
  return num + 1;
}
```
  - 引数の型注釈を省略した場合、コンパイラーはany型と暗黙的に解釈
  - コンパイラーオプションのnoImplicitAnyをtrueに設定することで、引数の型注釈を必須に
  - 戻り値の型注釈を省略した場合、コンパイラーがコードから型推論する
  - returnが複数あり違う型を返している場合推論される型はユニオン型
  ```
  function getFirst(items: number[]) {
    if (typeof items[0] === "number") {
      return items[0];
    }
    return null;
  }

  getFirst([1, 2, 3]);
  // function getFirst(items: number[]): number | null
  ```

- 関数式
  - 式とは、評価した結果が値になるものを言い、関数式は値になるので、変数に直接代入できる
  ```
  const 変数名 = function 関数名(引数) {
    // 処理内容
  };
  ```
  - 匿名関数や無名関数
    - 関数名を省略できる
    ```
    const 変数名 = function () {};
    
    関数式を呼び出すには、変数名を使う
    変数名(); // 呼び出し
    ```
  - 関数式は、オブジェクトのプロパティに直接代入することもできる
  ```
  const オブジェクト = {
    メソッド名: function () {},
  };
  ```














