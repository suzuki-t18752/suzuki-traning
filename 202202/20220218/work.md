## javascript sortメソッド
- 配列の並び替えを行う
- 破壊的メソッド(inplace)
- 引数が与えられなかった場合
  - 文字列はUTF-16単位順
  - 数値は文字列に変換される(Unicode順)
    - 9と80なら80が前
  - undefinedは最後尾
- 引数compareFunction(a, b)が与えられる場合
  - 指定した引数(関数)の
    - 返り値が0より小さい値ならaが前に
    - 返り値が0より大きい値ならbが前に
    - 返り値が0なら並び替えない

### どういうエラーなのかはエラーメッセージを変えて判断出来るようにしよう
### エラーハンドリングを変える場合(rescue)のみエラークラスを定義するように！！！
### エラー時の状況確認に必要なのは生のデータだよ！！！！！
- エラー時に受け取るのはこちらが想定していないデータなのでそもそも形を変えられないし、変えるべきではない

### nkf
- 「nkf」は「Network Kanji Filter」の略で、LinuxとWindowsなど、異なるOS間でテキストデータを交換する際に問題となる文字コードと改行コードを変換する
- ruby https://docs.ruby-lang.org/ja/latest/class/NKF.html
- nkfについて https://atmarkit.itmedia.co.jp/ait/articles/1609/29/news016.html
```
::NKF.nkf('-w', @agent.page.body)
出力するエンコーディングを指定する
-w UTF-8 を出力する(BOMなし)


[7] pry(main)> ::NKF.nkf('-w', 'testnrvnkgvdsni')
=> "testnrvnkgvdsni"
[8] pry(main)> ::NKF.nkf('-j', 'testnrvnkgvdsni')
=> "\x74\x65\x73\x74\x6E\x72\x76\x6E\x6B\x67\x76\x64\x73\x6E\x69"
[9] pry(main)> ::NKF.nkf('-s', 'testnrvnkgvdsni')
=> "testnrvnkgvdsni"
[10] pry(main)> ::NKF.nkf('-e', 'testnrvnkgvdsni')
=> "testnrvnkgvdsni"
[11] pry(main)> ::NKF.nkf('-e', 'testnrv\n kgvdsni')
=> "testnrv\\n kgvdsni"
[12] pry(main)> ::NKF.nkf('-s', 'testnrv \n kgvdsni')
=> "testnrv \\n kgvdsni"
[16] pry(main)> ::NKF.nkf('-w -h1', 'カタカナ')
=> "かたかな"
[17] pry(main)> ::NKF.nkf('-w -h2', 'ひらがな')
=> "ヒラガナ"
[18] pry(main)> ::NKF.nkf('-w -h3', 'ひらがなカタカナ')
=> "ヒラガナかたかな"
```
### バッファリング
- バッファリングとは、複数の機器やソフトウェアの間でデータをやり取りするときに、処理速度や転送速度の差を補ったり、通信の減速や中断に備えて専用の記憶領域に送受信データを一時的に保存しておくこと
- 時的にバッファーメモリーなどにデータを蓄え、データ処理速度や処理にかかる時間の違いを調整すること
- 動画コンテンツのストリーミング配信などで、映像データをあらかじめ蓄えておき、回線の遅延によって動画が途切れないようにすること


### ruby Threardクラス joinメソッド
```
def test
  new_thread = Thread.new do
    fail
  end
end
[2] pry(main)> test
=> #<Thread:0x000055b623394f20 (pry):2 run>
[3] pry(main)> #<Thread:0x000055b623394f20 (pry):2 run> terminated with exception (report_on_exception is true):
Traceback (most recent call last):
(pry):3:in `block in test': unhandled exception

def test
  new_thread = Thread.new do
    fail
  end
  new_thread.join
end
[4] pry(main)> test
#<Thread:0x00007fe8e03a7f70 (pry):8 run> terminated with exception (report_on_exception is true):
Traceback (most recent call last):
(pry):9:in `block in test': unhandled exception
RuntimeError:
from (pry):9:in `block in test'
```
- joinしたthreadの実行が終了するまで現在のthreadの実行を停止する
- joinしたthreadの実行が例外で終了している場合現在のthreadはその例外を受け取る


### ruby Objectクラス tapメソッド
- ブロック内で処理を実行し、処理結果に関わらず、オブジェクトの返り値をそのまま返すメソッド
```
[1] pry(main)> def test
[1] pry(main)*   p 'test'
[1] pry(main)* end
=> :test
[2] pry(main)> test
"test"
=> "test"
[4] pry(main)> test.tap {|x| p x + 'だよ' }
"test"
"testだよ"
=> "test"
```
