## オプショナルチェーン
- javascriptにてメソッドの後ろに「?」を付けてメソッドを呼び出すことで呼び出し元に呼び出したいメソッドがなくてもエラーにならず、undefinedを返す
  - a?.present
- rubyにもあるよ

## runtime
- プログラムの実行時のこと

## トランスパイル
- その言語の古い書き方に変換すること
- ユーザーの古い環境に対応出来てプログラマは最新の書き方、機能を使う事が出来る

## null安全
- 実行時にnullが原因のエラーを発生させないような仕組み
- https://qiita.com/koher/items/e4835bd429b88809ab33

## プリミティブ型
- プログラミング言語などが仕様として提供する基本的なデータ型

## nullとundefined
- null
  - 意図的に値がないことを示す
- undefined
  - 初期化されていない、値が一度も設定されていない

- javascript
  - null
    - プリミティブな値
  - undefined
    - プリミティブな型
```
> typeof null
'object'
> typeof undefined
'undefined'
```
