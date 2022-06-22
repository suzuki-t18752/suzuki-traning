# rubyのメモ

- rubyはオブジェクト指向言語

- rubyを扱うファイルの拡張子
  - ファイル名.rb
- rubyのファイルを実行する
  - ruby ファイル名

- rubyの変数はオブジェクトそのものではなく、オブジェクトへの参照が格納されている
  ```
  数値は同じオブジェクトを参照しているが、文字列は違うオブジェクトを参照しているのがわかる
    irb(main):097:0> a = 1
    irb(main):098:0> a.object_id
    => 3
    irb(main):099:0> 1.object_id
    => 3
    irb(main):100:0> b = 1
    irb(main):101:0> b.object_id
    => 3
    irb(main):102:0> c = 'test'
    irb(main):103:0> c.object_id
    => 180
    irb(main):104:0> d = 'test'
    irb(main):105:0> d.object_id
    => 200
    irb(main):106:0> 'test'.object_id
    => 220
  変数を別の変数に入れると同じ参照先を見る
    irb(main):107:0> e = c
    irb(main):108:0> e.object_id
    => 180
  参照先が同じだと変更が反映される
    irb(main):109:0> c.chop!
    => "tes"
    irb(main):110:0> d
    => "test"
    irb(main):111:0> e
    => "tes"
  ```

- 基礎文法
  - メソッドの呼び出し
    ```
    オブジェクト.メソッド(引数1, 引数2)
    引数はカッコなしでも良い
    オブジェクト.メソッド 引数1, 引数2
    ```
  - 文の区切り
    - 改行
    - 文の最後に;を付ける
    - \を付けると改行をしてても文が続いていることになる
  - コメント
    - 文の最初に#を付ける

  - 変数
    - 宣言と代入
      ```
      変数名 = 値や式

      変数名は下記のように小文字のスネークケース(アンダーバーで単語を区切ること)
      使えるのはアルファベットの小文字とアンダーバー、数字
      test_dayo123 = 1

      下記のように変数をまとめて宣言、代入することも出来る
      irb(main):001:0> a, b = 1, 2
      irb(main):002:0> a
      => 1
      irb(main):003:0> b
      => 2

      代入する値が少ない場合はnilが入る
      irb(main):004:0> a, b = 1
      irb(main):005:0> a
      => 1
      irb(main):006:0> b
      => nil
      ```
   - 文字列
     ```
     シングルもしくはダブルクフォートで囲う
     'test'
     "test"

     特殊文字を使う場合はダブルクフォート
     "test\ntest"
     ```
     - 式展開
       ```
       文字列に式の値を与えることが出来る
       irb(main):007:0> a = 'aaaa'
        irb(main):008:0> "bbbb#{a}bbbbb"
        => "bbbbaaaabbbbb"
       ```
     - 文字の連結
      ```
      irb(main):009:0> 'bbbbb' + a
      => "bbbbbaaaa"
      ```
     - %記法
      - %q!文字列!
        - シングルクフォートと同じ
          ```
          irb(main):025:0> %q!test!
          => "test"
          ```
      - %Q!文字列!
        - ダブルクフォートと同じ
          ```
          irb(main):026:0> a = 1
          irb(main):027:0> %Q!test#{a}!
          => "test1"
          
          Qがなくてもいける
            irb(main):029:0> %!test#{a}!
            => "test1"
          
          !の部分は適当な記号でOK
            irb(main):030:0> %?test#{a}?
            => "test1"
          ```
       
      - ヒアドキュメント
        - 適当な識別子を指定することで改行をして文字列を作ることが出来る
          ```
          irb(main):031:0" a = <<TEXT
          irb(main):032:0" test
          irb(main):033:0" test
          irb(main):034:0> TEXT
          irb(main):035:0> a
          => "test\ntest\n"
          
          -を付けると最後の識別子をインデントさせることが出来る
            irb(main):031:0" a = <<TEXT
            irb(main):032:0" test
            irb(main):033:0" test
            irb(main):034:0>    TEXT
            irb(main):035:0> a
            => "test\ntest\n"
          -がないとヒアドキュメントとして認識されない
          
          
          ~を付けると文字列の先頭の空白を認識してくれる
            irb(main):052:0" <<~TEXT
            irb(main):053:0" test
            irb(main):054:0> TEXT
            => "test\n"
            irb(main):055:0" <<TEXT
            irb(main):056:0"     test
            irb(main):057:0> TEXT
            => "    test\n"
            
          式展開も出来る
            irb(main):001:0> a = 1
            irb(main):002:0" <<TEXT
            irb(main):003:0" #{a}text
            irb(main):004:0> TEXT
            => "1text\n"
          シングルクフォートを付けると式展開を無効出来る
            irb(main):005:0' <<'TEXT'
            irb(main):006:0' #{a}text
            irb(main):007:0> TEXT
            => "\#{a}text\n"
          ```


   - 数値
    ```
    基本、少数、負の数
    irb(main):010:0> 1
    => 1
    irb(main):011:0> 100
    => 100
    irb(main):012:0> -100
    => -100
    irb(main):013:0> 1.5
    => 1.5
    irb(main):014:0> -0.5
    => -0.5
    アンダーバーもいれることが出来るが無視される
    irb(main):015:0> 1_0_0
    => 100
    四則演算
    irb(main):016:0> 1 + 1
    => 2
    irb(main):017:0> 2 - 1
    => 1
    irb(main):019:0> 2 * 2
    => 4
    irb(main):020:0> 4 / 2
    => 2
    変数の前に-を付けると負の数に出来る
    irb(main):021:0> a = 1
    irb(main):022:0> -a
    => -1
    %で計算すると余りを出せる
    irb(main):008:0> 5%3
    => 2
    ```
    - 小数点以下の値
    ```
    整数同士だと小数点以下が切り捨てられる
    irb(main):001:0> 1/2
    => 0
    片方の値が小数だと表示される
    irb(main):002:0> 1.0/2
    => 0.5
    irb(main):003:0> 1/2.0
    => 0.5
    irb(main):011:0> 5/12.0
    => 0.4166666666666667
    to_fメソッドで小数に直してもよい
    irb(main):004:0> 1.to_f/2
    => 0.5
    irb(main):005:0> 1.to_f
    => 1.0
    ```
    - 値の比較
    ```
    irb(main):012:0> 1 > 2
    => false
    irb(main):013:0> 1 < 2
    => true
    irb(main):014:0> 1 >= 1
    => true
    irb(main):015:0> 1 == 1
    => true
    irb(main):016:0> 1 != 2
    => true
    ```
    - 演算の省略
    ```
    irb(main):017:0> n = 1
    irb(main):018:0* n++
    irb(main):019:0* ^C
    irb(main):018:0> n += 1
    irb(main):019:0> n
    => 2
    irb(main):020:0> n -= 1
    irb(main):021:0> n
    => 1
    irb(main):022:0> n *= 3
    irb(main):023:0> n
    => 3
    irb(main):029:0> n *= 2
    irb(main):030:0> n
    => 6
    irb(main):031:0> n /= 2
    irb(main):032:0> n
    => 3
    nの2乗が出来ている
      irb(main):033:0> n **= 2
      irb(main):034:0> n
      => 9
    ```
    
    - 10進数以外の数値
      ```
      0bを先頭に付けると２進数になる
        irb(main):001:0> 0b00001111
        => 15
      0から始めると８進数になる
        irb(main):002:0> 0077
        => 63
      0xから始めると16進数になる
        irb(main):004:0> 0x1f
        => 31
      ```
    - ビット演算
      - &は同じビットがたっている部分を出力
      - |はそれぞれで立っているビット全てを出力
        ```
        irb(main):014:0> 0b0001
        => 1
        irb(main):015:0> 0b0010
        => 2
        irb(main):016:0> 0b0001 + 0b0010
        => 3
        irb(main):017:0> 0b0001 & 0b0010
        => 0
        irb(main):018:0> 0b0001 | 0b0010
        => 3
        irb(main):019:0> 0b0001 | 0b0001
        => 1
        irb(main):020:0> 0b0001 & 0b0001
        => 1
        ```
      - ^はXORでどちらか片方しかビットがたっていない場合に1を出力する
        ```
        irb(main):021:0> 0b0001 ^ 0b0001
        => 0
        irb(main):022:0> 0b0001 ^ 0b0010
        => 3
        irb(main):023:0> 0b0001 << 0b0010
        => 4
        irb(main):024:0> 0b0001 >> 0b0010
        => 0
        ```
      - 指数
        ```
        2*10の-3乗
          irb(main):025:0> 2e-3
          => 0.002
        2*10の3乗
          irb(main):026:0> 2e3
          => 2000.0
        ```
      - 数値のクラス
        ```
        Integer 実数
          irb(main):030:0> 1.class
          => Integer
        Float 小数
          irb(main):031:0> 1.0.class
          => Float
        Rational 有理数
          irb(main):034:0> 2.to_r
          => (2/1)
          irb(main):035:0> 2.to_r.class
          => Rational
          irb(main):036:0> 0.3i.class
          => Complex
          irb(main):037:0> '1'.to_c.class
          => Complex
        ```
      
    
  - 数値と文字列は暗黙的に変換されない
    ```
    irb(main):035:0> 1 + 'test'
    Traceback (most recent call last):
            5: from /usr/bin/irb:23:in `<main>'
            4: from /usr/bin/irb:23:in `load'
            3: from /usr/lib/ruby/gems/2.7.0/gems/irb-1.2.1/exe/irb:11:in `<top (required)>'
            2: from (irb):35
            1: from (irb):35:in `+'
    TypeError (String can't be coerced into Integer)
    irb(main):036:0> 1 + 'test'.to_i
    => 1
    irb(main):037:0> 'test'.to_i
    => 0
    irb(main):038:0> 1.to_s + 'test'
    => "1test"
    式展開をした場合は文字列として扱われる
      irb(main):040:0> "#{n}test"
      => "9test"
    ```
  - 真偽値
    - falseもしくはnilが偽
      - ruby以外の言語だとnilが偽でない場合もある
    - それ以外の値は真
  - 論理演算子
    - &&
      - どちらかが偽の値だった場合その場で偽の値を返す
      - どちらの値も真の値だった場合は最後に参照された値を返す
        ```
        irb(main):041:0> 1 && 1
        => 1
        irb(main):042:0> 1 && nil
        => nil
        irb(main):045:0> true && false
        => false
        irb(main):046:0> true && true
        => true
        irb(main):047:0> false && true
        => false
        ```
    - ||
      - 最初に真の値になった値を返す
      - どちらも偽の値の場合、最後に参照された値を返す
        ```
        irb(main):043:0> 1 || 1
        => 1
        irb(main):044:0> nil || 1
        => 1
        irb(main):048:0> true || true
        => true
        irb(main):049:0> false || true
        => true
        irb(main):050:0> true || false
        => true
        irb(main):059:0> false || nil
        => nil
        irb(main):060:0> false || false
        => false
        ```
    - 論理演算子の優先度
      1. !
      2. &&
      3. ||
      4. not
      5. and, or
      ```
      irb(main):045:0> false || true
      => true
      irb(main):046:0> !false || true
      => true
      irb(main):047:0> not false || true
      => false
      irb(main):048:0> not false
      => true
      !の方が||より優先度が高い
        irb(main):049:0> !false || true
        => true
      notの方が||より優先度が低い
        irb(main):051:0> not(false || true)
        => false
      ```
        
  - カッコ()で優先度が変わる
    ```
    irb(main):061:0> 1 + 1 * 2
    => 3
    irb(main):062:0> (1 + 1) * 2
    => 4
    irb(main):074:0> 1 && 2 || 3 && 4
    => 2
    irb(main):075:0> 1 && (2 || 3) && 4
    => 4
    ```
  - if文
    ```
    if 条件式1
      条件式1が真の値だった場合
    elsif 条件式2
      条件式1が偽で条件式2が真だった場合
    elsif 条件式3
      条件式2が偽で条件式3が真だった場合
    else
      上の全ての条件式が偽だった場合
    end

    irb(main):002:0> n = 1
    irb(main):003:1* if n == 1
    irb(main):004:1*   true
    irb(main):005:1* else
    irb(main):006:1*   false
    irb(main):007:0> end
    => true
    irb(main):008:0> n = 2
    irb(main):009:1* if n == 1
    irb(main):010:1*   true
    irb(main):011:1* else
    irb(main):012:1*   false
    irb(main):013:0> end
    => false

    代入も出来る
      irb(main):020:0* a =
      irb(main):021:1* if n > 1
      irb(main):022:1*   'でかい'
      irb(main):023:1* else
      irb(main):024:1*   '小さい'
      irb(main):025:0> end
      irb(main):026:0> a
      => "でかい"

    ifを後ろにつけることも出来る
      irb(main):029:0> n
      => 3
      irb(main):027:0> true if n > 2
      => true
      irb(main):028:0> true if n > 4
      => nil

    thenを使うと1行で書ける
      irb(main):030:1* if n == 1 then 1
      irb(main):031:1* elsif n > 1 then true
      irb(main):032:1* else false
      irb(main):033:0> end
      => true
    ```
  - unless
    - ifの逆で式が偽だった場合に値を返す
      ```
      irb(main):052:0> 1 unless false
      => 1
      irb(main):053:0> 1 if false
      => nil
      irb(main):054:1* unless false
      irb(main):055:1*   1
      irb(main):056:1* else
      irb(main):057:1*   2
      irb(main):058:0> end
      => 1
      irb(main):059:1* unless true
      irb(main):060:1*   1
      irb(main):061:1* else
      irb(main):062:1*   2
      irb(main):063:0> end
      => 2
      ```
  - case文
    ```
    基本
      case 対象の値
      when 値1
        対象の値が値1に一致した場合に返す値
      when 値2
        対象の値が値2に一致した場合に返す値
      else
        どれにも一致しなかった場合に返す値
      end
      
    irb(main):064:1* case 1
    irb(main):065:1* when 2
    irb(main):066:1*   2
    irb(main):067:1* when 1
    irb(main):068:1*   1
    irb(main):069:1* else
    irb(main):070:1*   3
    irb(main):071:0> end
    => 1
    irb(main):072:1* case 4
    irb(main):073:1* when 2
    irb(main):074:1*   2
    irb(main):075:1* when 1
    irb(main):076:1*   1
    irb(main):077:1* else
    irb(main):078:1*   3
    irb(main):079:0> end
    => 3
    ```
  - 三項演算子
    - if文を省略して書くことが出来る
      ```
      irb(main):080:0> 1 ? 'test' : 'tetete'
      => "test"
      irb(main):081:0> false ? 'test' : 'tetete'
      => "tetete"
      ```
      
  - メソッドの定義
    - メソッド名も変数と同じ命名の仕方
      ```
      基本
        def メソッド名(引数1, 引数2, …, …)
          処理
        end

      ()の引数なしでも良い
        def メソッド名
          処理
        end

      irb(main):001:1* def a
      irb(main):002:1*   1
      irb(main):003:0> end
      => :a
      irb(main):004:0> a
      => 1

      irb(main):005:1* def b(a)
      irb(main):006:1*   1 + a
      irb(main):007:0> end
      => :b
      引数が必要なのに引数がないとエラーになる
        irb(main):008:0> b
        Traceback (most recent call last):
                5: from /usr/bin/irb:23:in `<main>'
                4: from /usr/bin/irb:23:in `load'
                3: from /usr/lib/ruby/gems/2.7.0/gems/irb-1.2.1/exe/irb:11:in `<top (required)>'
                2: from (irb):8
                1: from (irb):5:in `b'
        ArgumentError (wrong number of arguments (given 0, expected 1))

      rubyは最後に呼び出された値が戻り値になる
        irb(main):009:0> a = 2
        irb(main):011:0> b(a)
        => 3

      returnを付けることも出来る
        irb(main):014:1* def c
        irb(main):015:1*   return 1
        irb(main):016:0> end
        => :c
        irb(main):017:0> c
        => 1
      ```
    - 引数のデフォルト値
        ```
        引数に値が入っていない状態でメソッドを実行するとエラーになるが、
        デフォルト値を指定することで引数に値がなしでも実行出来る
          irb(main):082:1* def a(b)
          irb(main):083:1*   b
          irb(main):084:0> end
          => :a
          irb(main):085:0> a
          Traceback (most recent call last):
                  5: from /usr/bin/irb:23:in `<main>'
                  4: from /usr/bin/irb:23:in `load'
                  3: from /usr/lib/ruby/gems/2.7.0/gems/irb-1.2.1/exe/irb:11:in `<top (required)>'
                  2: from (irb):85
                  1: from (irb):82:in `a'
          ArgumentError (wrong number of arguments (given 0, expected 1))
          irb(main):087:1* def a(b = 1)
          irb(main):088:1*   b
          irb(main):089:0> end
          => :a
          irb(main):090:0> a
          => 1
        ```
    - 真偽値を返すメソッドはメソッド名が?で終わる
    - !で終わるメソッドは破壊的メソッドが多いので注意

    - classメソッド
      - クラスの確認
        ```
        irb(main):018:0> 1.class
        => Integer
        irb(main):019:0> 'test'.class
        => String
        irb(main):020:0> true.class
        => TrueClass
        irb(main):021:0> nil.class
        => NilClass
        ```
  - ライブラリ
    - ライブラリの読み込み
      - require ライブラリ名
        ```
        irb(main):116:0> require 'date'
        => true
        irb(main):117:0> Date.new
        => #<Date: -4712-01-01 ((0j,0s,0n),+0s,2299161j)>
        irb(main):119:0> Date.today
        => #<Date: 2022-06-15 ((2459746j,0s,0n),+0s,2299161j)>
        
        自分で作成したrubyのファイルもrequireで読み込む
        require ./test.rb 等
        
        requireは1回しか読み込まないので2回目にやるとfalseになる
          irb(main):120:0> require 'date'
          => false
        ```
      - load ライブラリ名
        - loadはreqireと違い何度もライブラリを読み込める
        - しかし.rbは笑楽出来ない
        ```
        irb(main):001:0> require 'date.rb'
        => true
        irb(main):002:0> require 'date.rb'
        => false
        irb(main):003:0> load 'date.rb'
        => true
        irb(main):004:0> load 'date'
        Traceback (most recent call last):
              5: from /usr/bin/irb:23:in `<main>'
              4: from /usr/bin/irb:23:in `load'
              3: from /usr/lib/ruby/gems/2.7.0/gems/irb-1.2.1/exe/irb:11:in `<top (required)>'
              2: from (irb):4
              1: from (irb):4:in `load'
        LoadError (cannot load such file -- date)
        ```
      - require_relative
        - requireはrubyを実行しているディレクトリが起点となるが、ファイルを読み込んでいるディレクトリが起点となる
  
  - p, puts, print 
    - puts, printは一般ユーザー向け
      - 内部的にto_sメソッドが呼び出されている
    - pは開発者向け
      - 内部的にinspectメソッドが呼び出されている
      ```
      putsは標準出力に表示された後nilが返り、改行が反映される
      printも標準出力に表示された後nilが返り、改行が反映される
      pは標準出力に表示された後そのまま表示された値を返す、改行も特殊文字で表される
        irb(main):005:0> puts 1
        1
        => nil
        irb(main):006:0> print 1
        1=> nil
        irb(main):007:0> p 1
        1
        => 1
        irb(main):008:0' puts 'test
        irb(main):009:0> test'
        test
        test
        => nil
        irb(main):010:0' print 'test
        irb(main):011:0> test'
        test
        test=> nil
        irb(main):012:0' p 'test
        irb(main):013:0> test'
        "test\ntest"
        => "test\ntest"
      ```
  - divmodメソッド
    - 数値を割った商と余りを配列で返す
      ```
      irb(main):074:0> 13.divmod(2)
      => [6, 1]
      ```
  - size(length)メソッド
    - 配列の個数を返す
      ```
      irb(main):043:0> [1, 2, 3].size
      => 3
      irb(main):045:0> [1, 2, 3].length
      => 3
      ```

- 配列
  - 配列はArrayクラス
    ```
    irb(main):008:0> [1, 2, 3].class
    => Array
    
    配列は添え字(インデックス)を指定することで値を取り出せる
    インデックスは0から始まる
      irb(main):009:0> [1, 2, 3][0]
      => 1
      irb(main):010:0> [1, 2, 3][1]
      => 2
    値の無いインデックスを指定するとnilが返る
      irb(main):042:0> [1, 2, 3][50]
      => nil
      
    sizeメソッドやlengthメソッドで配列内の値の個数を確認で出来る
    (lengthはsizeのエイリアスメソッド)
      irb(main):043:0> [1, 2, 3].size
      => 3
      irb(main):045:0> [1, 2, 3].length
      => 3
      
    改行して作成することも出来る
    複数の型を入れることも出来る
      irb(main):036:1* [
      irb(main):037:1*   1,
      irb(main):038:1*   2,
      irb(main):039:1*   'test',
      irb(main):040:1*   [1,2,3]
      irb(main):041:0> ]
      => [1, 2, "test", [1, 2, 3]]
      
      
    インデックスを指定して値を新しい値を入れることも出来る
      irb(main):048:0> a = [1, 2, 3]
      irb(main):049:0> a
      => [1, 2, 3]
      irb(main):050:0> a[0] = 100
      irb(main):051:0> a
      => [100, 2, 3]
    元の大きさよりも大きいインデックスを指定すると間の値はnilで埋められている
      irb(main):052:0> a[10] = 100
      irb(main):053:0> a
      => [100, 2, 3, nil, nil, nil, nil, nil, nil, nil, 100]
      irb(main):054:0> a.size
      => 11
    
    <<を使うことで最後尾に値を追加出来る
      irb(main):055:0> a << 1
      => [100, 2, 3, nil, nil, nil, nil, nil, nil, nil, 100, 1]
      
    delete_atメソッドで指定したインデックスの値を削除出来る
      irb(main):057:0> a.delete_at(0)
      => 100
      irb(main):058:0> a
      => [2, 3, nil, nil, nil, nil, nil, nil, nil, 100, 1]
      
    複数の変数に同時に値を入れることも出来る
      irb(main):062:0> a, b, c = [1, 3, 5]
      irb(main):063:0> a
      => 1
      irb(main):064:0> b
      => 3
      irb(main):065:0> c
      => 5
    変数の数よりも配列の数が少ない場合は変数にnilは入る
      irb(main):066:0> a, b, c = [1, 3]
      irb(main):067:0> a
      => 1
      irb(main):068:0> b
      => 3
      irb(main):069:0> c
      => nil
    変数の数が少なくてもOK
      irb(main):070:0> a, b = [1, 3, 5]
      irb(main):071:0> a
      => 1
      irb(main):072:0> b
      => 3
    ```
  - eachメソッド
    - ブロック内の処理の実行後に元の配列の値をそのまま返す
      ```
      irb(main):075:1* [1,2,3].each do |i|
      irb(main):076:1*   p i
      irb(main):077:0> end
      1
      2
      3
      => [1, 2, 3]
      ```
  - delete_ifメソッド
    - ブロック内の返り値が真の値の場合、配列から削除し配列を返す
      ```
      irb(main):080:0> [1, 2, 3].delete_if {|i| i == 2}
      => [1, 3]
      irb(main):081:0> [1, 2, 3].delete_if {|i| i == 3}
      => [1, 2]
      irb(main):082:0> [1, 2, 3].delete_if {|i| true}
      => []
      irb(main):083:0> [1, 2, 3].delete_if {|i| false}
      => [1, 2, 3]
      ```
  - mapメソッド(エイリアスメソッドはcollect)
    - ブロックの返り値を配列にして返す
      ```
      irb(main):096:0> [1,2,3].map {|n| n}
      => [1, 2, 3]
      irb(main):097:0> [1,2,3].map {|n| n - 1}
      => [0, 1, 2]
      ```
  - selectメソッド(エイリアスメソッドはfind_all)
    - ブロックの帰り値が真だった配列の値を返す
      ```
      irb(main):101:0> [1,2,4].select {|n| n % 2 == 0 }
      => [2, 4]
      irb(main):102:0> [1,2,4].select {|n| n % 2 == 1 }
      => [1]
      ```
  - rejectメソッド
    - ブロックの返り値が偽だった配列の値を返す
      ```
      irb(main):103:0> [1,2,4].reject {|n| n % 2 == 0 }
      => [1]
      irb(main):104:0> [1,2,4].reject {|n| n % 2 == 1 }
      => [2, 4]
      ```
  - findメソッド(エイリアスメソッドはdetect)
    - ブロックの返り値が最初に真になった配列の値を返す
      ```
      irb(main):105:0> [1,2,4].find {|n| n % 2 == 0 }
      => 2
      irb(main):106:0> [1,2,4].find {|n| n % 2 == 1 }
      => 1
      ```
  - inject(エイリアスメソッドはreduce)
    - 第1引数に配列の最初の値が入り、２回目以降がブロックの返り値が第1引数に入れられて、最後の実行で第1引数を返り値として返す
      ```
      irb(main):107:0> [1,2,4].inject {|result| result}
      => 1
      irb(main):109:0> [1,2,4].inject {|result, n| result + n }
      => 7
      ```
      
  

- ブロック
  - doからendまでの部分のこと
  - |i|のことをブロック引数と言う
    ```
    irb(main):075:1* [1,2,3].each do |i|
    irb(main):076:1*   p i
    irb(main):077:0> end
    1
    2
    3
    => [1, 2, 3]
    
    ブロック引数は自由に指定出来る
      irb(main):084:0> [1, 2, 3].each {|num| p num}
      1
      2
      3
      => [1, 2, 3]
    ```
  - {}を使うことで1行で指定することも出来る
    ```
    irb(main):079:0> [1, 2, 3].each {|i| p i}
    1
    2
    3
    => [1, 2, 3]
    ```
  - ブロック内で外部の引数を扱うことも出来る
    ```
    irb(main):085:0> n = 0
    irb(main):090:0> [1, 2, 3].each {|num| n += num}
    => [1, 2, 3]
    irb(main):091:0> n
    => 6
    ```
  - 逆にブロック内の値をブロック外で使うことはできない
    ```
    irb(main):094:0> [1, 2, 3].each {|num| x = 0; x += num; p x}
    1
    2
    3
    => [1, 2, 3]
    irb(main):095:0> x
    Traceback (most recent call last):
            4: from /usr/bin/irb:23:in `<main>'
            3: from /usr/bin/irb:23:in `load'
            2: from /usr/lib/ruby/gems/2.7.0/gems/irb-1.2.1/exe/irb:11:in `<top (required)>'
            1: from (irb):95
    NameError (undefined local variable or method `x' for main:Object)
    ```
  - ブロックの簡略化
    ```
    irb(main):110:0> [1,2,3].map {|n| n.to_s }
    => ["1", "2", "3"]
    irb(main):111:0> [1,2,3].map(&:to_s)
    => ["1", "2", "3"]
    ```
    
- 範囲(Range)
  - 最初の値..最後の値で間に入る値を省略して表すことが出来る
    ```
    irb(main):121:0> (1..10).map {|n| n }
    => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    irb(main):122:0> ('a'..'d').map {|n| n }
    => ["a", "b", "c", "d"]
    ```
  - 配列や文字列の一部を取り出せる
    ```
    irb(main):002:0> [1,2,3,4,5][2..4]
    => [3, 4, 5]
    irb(main):003:0> '1234567'[1..4]
    => "2345"
    ```
  - ~以上~未満等どの範囲にいるのか確認する際も便利
    - include?メソッドと組みああせる
      ```
      irb(main):004:0> (0..10).include?(2)
      => true
      irb(main):005:0> (0..10).include?(11)
      => false
      ```
  - 連続した値の配列も簡単に作れる
    ```
    irb(main):006:0> (1..5).to_a
    => [1, 2, 3, 4, 5]
    irb(main):007:0> [*1..5]
    => [1, 2, 3, 4, 5]
    ```
    
    
    
- rjustメソッド
  - 文字数を指定することが出来る
  - デフォルトは半角スペース
  - 文字数が多い場合は変化しない
    ```
    irb(main):001:0> '0'.rjust(4)
    => "   0"
    irb(main):003:0> '0'.rjust(4, '0')
    => "0000"
    irb(main):004:0> '0'.rjust(4, '/')
    => "///0"
    irb(main):005:0> '000'.rjust(4, '/')
    => "/000"
    irb(main):006:0> '0000'.rjust(4, '/')
    => "0000"
    irb(main):007:0> '00000'.rjust(4, '/')
    => "00000"
    ```
- joinメソッド
  - 配列を指定した文字で連結する
  - 引数がなければ空文字と同じ
  ```
  irb(main):012:0> [1,2,3].join
  => "123"
  irb(main):013:0> [1,2,3].join('')
  => "123"
  irb(main):014:0> [1,2,3].join(' ')
  => "1 2 3"
  irb(main):015:0> [1,2,3].join(',')
  => "1,2,3"
  ```
    

- コマンド
  - ruby -v
    - バージョンの確認

  - irb
    - rubyをコマンドラインで使用出来る

- その他
  - リテラル
    - ソースコードに直接記載する数字や文字列のこと
  - 識別子
    - 変数やメソッド、クラス等に名前をつけることを識別子を言う
  - 予約語
    - 言語ごとに予め設定されている識別子、基本的には予約語は識別子として使えない
  - 特殊文字
    - \n 改行
    - \r キャリッジリターン(改行+行の先頭に移動)
    - \t タブ
  - 有理数
    - 整数と分数と0のこと
  - 破壊的メソッド
    ```
    下記のように元々変数の中の値が完全に変わって元に戻せなくなること
      irb(main):091:0> 'test'.chop
      => "tes"
      irb(main):092:0> a = 'test'
      irb(main):093:0> a.chop
      => "tes"
      irb(main):094:0> a
      => "test"
      irb(main):095:0> a.chop!
      => "tes"
      irb(main):096:0> a
      => "tes"
    ```
  - ガーベージコレクション
    - 使われなくなった使用炭メモリを回収して使える領域にすること
    - rubyではデフォルトで行われる
  - エイリアス
    - 別名のこと
  - DRY原則
    - Don`t repeat yourselfの略で繰り返しを避けること
    
