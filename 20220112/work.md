## ruby

### クラスメソッドとインスタンスメソッド
```
[22] pry(main)> class A
[22] pry(main)*   def a
[22] pry(main)*     p 'test'
[22] pry(main)*   end
[22] pry(main)* end
=> :a
[23] pry(main)> A
=> A
[24] pry(main)> A.a
NoMethodError: undefined method `a' for A:Class
from (pry):28:in `<main>'
[25] pry(main)> A.new.a
"test"
=> "test"
[26] pry(main)> class A
[26] pry(main)*
[26] pry(main)> A.new.a
"test"
=> "test"
[27] pry(main)> class B
[27] pry(main)*   def self.b
[27] pry(main)*     p 'self'
[27] pry(main)*   end
[27] pry(main)* end
=> :b
[28] pry(main)> B.b
"self"
=> "self"
[29] pry(main)> class C
[29] pry(main)*   class << self
[29] pry(main)*     def c
[29] pry(main)*       p 'class_self'
[29] pry(main)*     end
[29] pry(main)*   end
[29] pry(main)* end
=> :c
[30] pry(main)> C.c
"class_self"
=> "class_self"
[32] pry(main)> class D < C
[32] pry(main)*   def d
[32] pry(main)*     p 'test'
[32] pry(main)*   end
[32] pry(main)* end
=> :d
[33] pry(main)> D.d
NoMethodError: undefined method `d' for D:Class
from (pry):55:in `<main>'
[34] pry(main)> D.c
"class_self"
=> "class_self"
```
- rubyではクラス内にメソッドを定義するとインスタンスメソッドとして扱う
  - クラスを.newでインスタンス化しないと呼び出せない
- クラスメソッドを指定する場合はメソッドの前にself.を付けるか、class << selfの形で再度クラスを定義する
  - クラスメソッドはインスタンス化しなくても呼び出せる

### メソッドの引数にアスタリスク
- アスタリスク1つなら可変長引数、アスタリスク2つならオプション引数
- 可変長引数
  - *をつければ引数を、配列に指定できる
  ```
  [35] pry(main)> def array(*a)
  [35] pry(main)*   pp a
  [35] pry(main)* end
  => :array
  [36] pry(main)> array(1,2)
  [1, 2]
  => [1, 2]
  [37] pry(main)> array(1)
  [1]
  => [1]
  ```
  - 過剰な引数を無視することが出来る
  ```
  [45] pry(main)> def array(a, *)
  [45] pry(main)*   p "#{a} Hello!!!"  !!"
  [45] pry(main)* end
  => :array
  [46] pry(main)> array(1, 2)
  "1 Hello!!!"
  => "1 Hello!!!"
  [47] pry(main)> array(1, 2, 3)
  "1 Hello!!!"
  => "1 Hello!!!"
  [48] pry(main)> def array(a)
  [48] pry(main)*   p "#{a} Hello!!!"
  [48] pry(main)* end
  => :array
  [49] pry(main)> array(1, 2)
  ArgumentError: wrong number of arguments (given 2, expected 1)
  from (pry):76:in `array'
  ```

- オプション引数
  - **をつければ引数を、ハッシュに指定できる
```
[39] pry(main)> def array(**a)
[39] pry(main)*   pp a
[39] pry(main)* end
=> :array
[40] pry(main)> array(b: 1, c: 2)
{:b=>1, :c=>2}
=> {:b=>1, :c=>2}
[41] pry(main)> array(1, 2)
ArgumentError: wrong number of arguments (given 2, expected 0)
from (pry):63:in `array'
[42] pry(main)> array(b => 1, c => 2)
NameError: undefined local variable or method `b' for main:Object
from (pry):68:in `<main>'
[43] pry(main)> array('b' => 1, 'c' => 2)
ArgumentError: wrong number of arguments (given 1, expected 0)
from (pry):63:in `array'
[44] pry(main)> array(:b => 1, :c => 2)
{:b=>1, :c=>2}
=> {:b=>1, :c=>2}
```

### 引数の指定はかっこを付けなくても出来るよ
- 配列やハッシュも
```
[7] pry(main)> def A(*a)
[7] pry(main)*   p "#{a} Hello!!!"
[7] pry(main)* end
=> :A
[8] pry(main)> A 1, 2, 3
"[1, 2, 3] Hello!!!"
=> "[1, 2, 3] Hello!!!"
[9] pry(main)> def A(**a)
[9] pry(main)*   p "#{a} Hello!!!"
[9] pry(main)* end
=> :A
[10] pry(main)> A 1, 2, 3
ArgumentError: wrong number of arguments (given 3, expected 0)
from (pry):17:in `A'
[11] pry(main)> A a: 1, b: 2
"{:a=>1, :b=>2} Hello!!!"
=> "{:a=>1, :b=>2} Hello!!!"
[12] pry(main)> def A(a)
[12] pry(main)*   p "#{a} Hello!!!"
[12] pry(main)* end
=> :A
[13] pry(main)> A 1
"1 Hello!!!"
=> "1 Hello!!!"
```

### flatten
- 多重配列を1つの配列にまとめる
```
[84] pry(main)> a = [1, [2, 3]]
=> [1, [2, 3]]
[85] pry(main)> a.flatten
=> [1, 2, 3]
[86] pry(main)> a = [1, [2, 3], 1]
=> [1, [2, 3], 1]
[87] pry(main)> a.flatten
=> [1, 2, 3, 1]
[88] pry(main)> a = [1, [2, 3], 2, 3, 4]
=> [1, [2, 3], 2, 3, 4]
[89] pry(main)> a = [1, [2, 3], [2, 3, 4]]
=> [1, [2, 3], [2, 3, 4]]
[90] pry(main)> a.flatten
=> [1, 2, 3, 2, 3, 4]
[91] pry(main)> a = [[1, [2, 3]], [2, 3, 4]]
=> [[1, [2, 3]], [2, 3, 4]]
[92] pry(main)> a.flatten
=> [1, 2, 3, 2, 3, 4]
```
