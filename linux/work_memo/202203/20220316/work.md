### stripメソッド ruby String
- https://docs.ruby-lang.org/ja/latest/method/String/i/strip.html
- 文字列の前後の空白(改行を含む)を削除する
```
[1] pry(main)> '\r\n'.strip
=> "\\r\\n"
[2] pry(main)> "\r\n".strip
=> ""
[3] pry(main)> "".strip
=> ""
[4] pry(main)> " ".strip
=> ""
[5] pry(main)> "　".strip
=> "　"
[6] pry(main)> "\s".strip
=> ""
[7] pry(main)> "\stest\s".strip
=> "test"
[8] pry(main)> "\stest\r\ntest\r\n".strip
=> "test\r\ntest"
## 連続してても消せる
[9] pry(main)> "\stest\r\ntest\r\n\r\n".strip
=> "test\r\ntest"
[10] pry(main)> "\stest\r\ntest\s\s\s\s".strip
=> "test\r\ntest"
```

### 正規表現 文字セット
- https://help.alteryx.com/2019.1/ja/boost/character_class_names.html
