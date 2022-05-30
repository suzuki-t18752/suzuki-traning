## ruby .superclass
- 継承元のクラスを確認出来る
- Class.superclass
```
[10] pry(main)> Table.find(1).class.superclass.class
=> Class
[11] pry(main)> Table.find(1).class.superclass.superclass
=> ActiveRecord::Base
[12] pry(main)> Table.find(1).class.superclass.superclass.superclass
=> Object
[13] pry(main)> Table.find(1).class.superclass.superclass.superclass.superclass
=> BasicObject
[14] pry(main)> Table.find(1).class.superclass.superclass.superclass.superclass.superclass
=> nil
```

## ruby メソッドの一覧を取得する
- Class.methods #クラスのメソッド一覧
- instance.instance_methods #クラスのインスタンスメソッド一覧
- instance.public_methods #publicなメソッド一覧
- instance.instance_public_methods #publicなインスタンスメソッド一覧
- instance.methods(false) #継承したメソッドは含まない

## ruby ancestors
- クラス、モジュールのスーパークラスとインクルードしているモジュールを優先順位順に配列にして返す


# メモ化（memoization）
- プログラムの高速化のための最適化技法の一種
- 関数呼び出しの結果を後で再利用するために保持し、呼び出し毎の再計算を防ぐ
