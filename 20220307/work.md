## ruby Hash invert
- https://docs.ruby-lang.org/ja/latest/method/Hash/i/invert.html
- ハッシュのキーを値にして、値をキーにする
```
[23] pry(main)> {a: 1, b: 2}.invert
=> {1=>:a, 2=>:b}
```

## ruby Hash transform_keys
- 全てのキーをブロック内の結果に変換する
```
[14] pry(main)> {a: 1, b: 2}.transform_keys { |k| "test#{k}" }
=> {"testa"=>1, "testb"=>2}
```

## cp932はShift_JIS(符号化文字集合 JIS X 0208 を使った文字符号化方式)に拡張文字が追加されたもの
