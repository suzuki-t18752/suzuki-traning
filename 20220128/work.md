### ruby 文字列の比較
- 文字の桁数、桁数が同じ場合はASCIIコード順を参照して比較する

### ruby ceil
- 指定した引数の桁数で切り上げする
```
[7] pry(main)> 2.1.ceil
=> 3
[8] pry(main)> 2.0.ceil
=> 2
[9] pry(main)> 2.9.ceil
=> 3
[14] pry(main)> 30.1.ceil(-1)
=> 40
[15] pry(main)> 30.1.ceil(-2)
=> 100
[16] pry(main)> 30.1.ceil(-4)
=> 10000
```

### ruby min
- 配列内の最小の値を取り出す
- 引数を指定せず該当の値がない場合はnilを返す
- 引数を指定して複数該当がある場合は配列で返す
- 文字列だと文字の桁数、桁数が同じ場合はASCIIコード順を参照して比較する

```
[17] pry(main)> [1,2].min
=> 1
[18] pry(main)> [1,2].min(2)
=> [1, 2]
[19] pry(main)> [1,2,3].min(2)
=> [1, 2]
[20] pry(main)> [].min(2)
=> []
[21] pry(main)> [].min
=> nil
[22] pry(main)> [1,1].min
=> 1
[23] pry(main)> [1,1,2].min
=> 1
[24] pry(main)> [1,1,2].min(2)
=> [1, 1]
[26] pry(main)> ['te', 'tet'].min
=> "te"
[27] pry(main)> ['te', '1'].min
=> "1"
[31] pry(main)> ['te', 'se'].min
=> "se"
[32] pry(main)> ['te', 'ue'].min
=> "te"
```
