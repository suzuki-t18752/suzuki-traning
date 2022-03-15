- SQLがどのように実行されているのかみて、データの流れを掴むとアプリを理解しやすいかも

## ruby attr_reader
- インスタンス変数と同じ名前、同じ値の変数を作成する
- インスタンス変数の初期値を保ったまま、インスタンス変数の値を利用出来る
- インスタンス変数同様インスタンス内で共有できるのがメリット
- 外部からこの変数にアクセス出来てしまう為、書き換えられた場所を追いにくい
- インスタンス変数を別の変数に入れて書き換えを行い、引数に入れる等して共有した方が安全な気はする
- https://docs.ruby-lang.org/ja/latest/method/Module/i/attr_reader.html
```
# attr_readerを使わない場合
[3] pry(main)> class A
[3] pry(main)*   def initialize(test)
[3] pry(main)*     @test = test
[3] pry(main)*   end
[3] pry(main)*   def a
[3] pry(main)*     @test = 1
[3] pry(main)*   end
[3] pry(main)* end
=> :a
[8] pry(main)> www = A.new('test')
=> #<A:0x000055fe3c2fba08 @test="test">
[9] pry(main)> www
=> #<A:0x000055fe3c2fba08 @test="test">
[10] pry(main)> www.a
=> 1
[11] pry(main)> www
=> #<A:0x000055fe3c2fba08 @test=1>
[3] pry(main)> A.new('test').test
NoMethodError: private method `test' called for #<A:0x000055fe3bc07260 @test="test">
from (pry):7:in `<main>'

# attr_readerを使う場合
[15] pry(main)> class A
[15] pry(main)*   attr_reader :test
[15] pry(main)*   def initialize(test)
[15] pry(main)*     @test = test
[15] pry(main)*   end
[15] pry(main)*   def a
[15] pry(main)*     test = 1
[15] pry(main)*   end
[15] pry(main)* end
=> :a
[16] pry(main)> www = A.new('test')
=> #<A:0x000055fe3b6327e0 @test="test">
[17] pry(main)> www = A.new('test')
=> #<A:0x000055fe3b5899b0 @test="test">
[18] pry(main)> www
=> #<A:0x000055fe3b5899b0 @test="test">
[19] pry(main)> www.a
=> 1
[20] pry(main)> www
=> #<A:0x000055fe3b5899b0 @test="test">
[21] pry(main)> www.test
=> "test"
```


### jis_x_0208
- 半角カナは対応していない
- [中黒について](https://ja.wikipedia.org/wiki/%E4%B8%AD%E9%BB%92)
- [半角カナ](https://ja.wikipedia.org/wiki/%E5%8D%8A%E8%A7%92%E3%82%AB%E3%83%8A)

### 半角カナ→全角カナ参考 javascript
- https://www.yoheim.net/blog.php?q=20191101
- 対応表を作る以外に方法はなさそう
```
function hankana2Zenkana(str) {
    var kanaMap = {
        'ｶﾞ': 'ガ', 'ｷﾞ': 'ギ', 'ｸﾞ': 'グ', 'ｹﾞ': 'ゲ', 'ｺﾞ': 'ゴ',
        'ｻﾞ': 'ザ', 'ｼﾞ': 'ジ', 'ｽﾞ': 'ズ', 'ｾﾞ': 'ゼ', 'ｿﾞ': 'ゾ',
        'ﾀﾞ': 'ダ', 'ﾁﾞ': 'ヂ', 'ﾂﾞ': 'ヅ', 'ﾃﾞ': 'デ', 'ﾄﾞ': 'ド',
        'ﾊﾞ': 'バ', 'ﾋﾞ': 'ビ', 'ﾌﾞ': 'ブ', 'ﾍﾞ': 'ベ', 'ﾎﾞ': 'ボ',
        'ﾊﾟ': 'パ', 'ﾋﾟ': 'ピ', 'ﾌﾟ': 'プ', 'ﾍﾟ': 'ペ', 'ﾎﾟ': 'ポ',
        'ｳﾞ': 'ヴ', 'ﾜﾞ': 'ヷ', 'ｦﾞ': 'ヺ',
        'ｱ': 'ア', 'ｲ': 'イ', 'ｳ': 'ウ', 'ｴ': 'エ', 'ｵ': 'オ',
        'ｶ': 'カ', 'ｷ': 'キ', 'ｸ': 'ク', 'ｹ': 'ケ', 'ｺ': 'コ',
        'ｻ': 'サ', 'ｼ': 'シ', 'ｽ': 'ス', 'ｾ': 'セ', 'ｿ': 'ソ',
        'ﾀ': 'タ', 'ﾁ': 'チ', 'ﾂ': 'ツ', 'ﾃ': 'テ', 'ﾄ': 'ト',
        'ﾅ': 'ナ', 'ﾆ': 'ニ', 'ﾇ': 'ヌ', 'ﾈ': 'ネ', 'ﾉ': 'ノ',
        'ﾊ': 'ハ', 'ﾋ': 'ヒ', 'ﾌ': 'フ', 'ﾍ': 'ヘ', 'ﾎ': 'ホ',
        'ﾏ': 'マ', 'ﾐ': 'ミ', 'ﾑ': 'ム', 'ﾒ': 'メ', 'ﾓ': 'モ',
        'ﾔ': 'ヤ', 'ﾕ': 'ユ', 'ﾖ': 'ヨ',
        'ﾗ': 'ラ', 'ﾘ': 'リ', 'ﾙ': 'ル', 'ﾚ': 'レ', 'ﾛ': 'ロ',
        'ﾜ': 'ワ', 'ｦ': 'ヲ', 'ﾝ': 'ン',
        'ｧ': 'ァ', 'ｨ': 'ィ', 'ｩ': 'ゥ', 'ｪ': 'ェ', 'ｫ': 'ォ',
        'ｯ': 'ッ', 'ｬ': 'ャ', 'ｭ': 'ュ', 'ｮ': 'ョ',
        '｡': '。', '､': '、', 'ｰ': 'ー', '｢': '「', '｣': '」', '･': '・'
    };

    var reg = new RegExp('(' + Object.keys(kanaMap).join('|') + ')', 'g');
    return str
            .replace(reg, function (match) {
                return kanaMap[match];
            })
            .replace(/ﾞ/g, '゛')
            .replace(/ﾟ/g, '゜');
};
```

### RegExp javascript
- パターンマッチを行える
```
/ab+c/i; // リテラル記法
上と同じ
new RegExp('ab+c', 'i')
```

### 無名関数
- https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Operators/function
- 関数名を付けないことで即時実行される関数を定義出来る、無名関数単体では使えない
```
> let Test2 = function(test) { return test + 'test'; }
undefined
> Test2(1)
'1test'
```
- アロー関数
  - https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Functions/Arrow_functions
```
> const Test = (test) => { return test + 'test'; }
undefined
> Test(1)
'1test'
```

### replace javascript
- https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/String/replace
- 第1引数に指定されたパターンに一致した文字列を第2引数の値に置換する
- 第1引数が文字列の場合、最初に一致した箇所のみを置き換える
```
// 最初に一致したもののみ(細かいのは正規表現を確認)
> 'test'.replace(/t/, '1')
'1est'
// 対象を全て
> 'test'.replace(/t/g, '1')
'1es1'
> 'test'.replace('test', '1')
'1'
> 'test'.replace('tes', '1')
'1t'
> 'test'.replace('aa', '1')
'test'
```
- 第二引数として関数を指定することが出来る
  - 第1引数で一致した場合のみ実行される
  - 関数の返り値は置換する文字として使われる
  - 関数に与えられる引数
    - match
      - 一致した部分文字列 (上記の $& に対応) です。
    - p1, p2, ...
      - replace() の第一引数が RegExp オブジェクトだった場合、n 番目の括弧でキャプチャされたグループの文字列 (上記の $1, $2, などに対応) です。例えば /(\a+)(\b+)/ が与えられた場合、p1 は \a+ に対する一致、p2 は \b+ に対する一致となります。
    - offset
      - 一致した部分文字列の、分析中の文字列全体の中でのオフセットです（例えば、文字列全体が 'abcd' で、一致した部分文字列が 'bc' ならば、この引数は 1 となります）。
    - string
      - 分析中の文字列全体です。
    - groups
      - 名前付きキャプチャグループに対応しているブラウザーのバージョンでは、使用されるグループ名をキーとし、一致した部分を値とするオブジェクトになります (一致しない場合は undefined)。
```
// match 第1引数に一致した値
// p1, p2, ... 第1引数に一致した値と何文字目で一致したのかの値
> 'test'.replace(/t/g, (match, p1, offset, string, groups) => { console.log(match, p1, offset, string, groups); return 1 })
t 0 test undefined undefined
t 3 test undefined undefined
'1es1'
```
