# minitest

- rubyのテスト用フレームワーク
- rubyのインストール時に最初から使える
- minitestは"test_"から始まるメソッドを探して実行するのでtest_からメソッド名を始めるのが必須

- インストール
```
gem install minitest -v 5.10.1
```

- サンプルコード
```
require 'minitest/autorun'

class SampleTest < Minitest::Test
  def test_sample
    assert_equal 'RUBY', 'ruby'.upcase
  end
end
```
サンプルコードの実行結果
```
suzukit@agrio___orio:~$ ruby sample_test.rb
Run options: --seed 17626

# Running:

.

Finished in 0.000721s, 1386.5106 runs/s, 1386.5106 assertions/s.

1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```




- assert_equal
  - assert_equal 期待する結果, テスト対象の式や値
  - 期待する結果とテスト対象の式や値が等しければパスする
  
- assert
  - assert テスト対象の式や値
  - テスト対象の式や値が真であればパスする

- refute
  - refute テスト対象の式や値
  - テスト対象の式や値が偽ならパスする


- 対象のメソッドやクラス等を実行するように呼び出してその返り値を検証している
```
def a
  'test'
end

require 'minitest/autorun'

class TestTest < Minitest::Test
  def test_a
    assert 'test', a
    assert a
    end
end
```

- テストファイルを分ける
  - requireでテストするファイルを読み込もう
```
require './test.rb'

class TestTest < Minitest::Test
  def test_a
    assert 'test', a
    assert a
    end
end
```

# テスト駆動開発の開発サイクル
1. テストコードを書く
2. テストが失敗することを確認する
3. 1つのテストをパスさせるためにの仮実装を置く
4. テストがパスすることを確認する
5. 別のテストパターンを書く
6. テストが失敗することを確認する
7. 仮実装ではなくロジックを書く
8. テストがパスすることを確認する
9. ロジックのリファクタリングをする
10. テストがパスすることを確認する

- 先にテストを書いて失敗させる
- テストがパスする最低限のコードを書く
- リファクタリングする
