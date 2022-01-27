## クラスメソッドはmix-inで引き継いだメソッドを使用出来ない！！！！！！
```
[1] pry(main)> class A
[1] pry(main)*   include ::Utils::Retryable
[1] pry(main)*   def self.a
[1] pry(main)*     with_retry do
[1] pry(main)*       p 'test'
[1] pry(main)*       fail(StandardError, 'test')
[1] pry(main)*     end
[1] pry(main)*   end
[1] pry(main)* end
=> :a
[2] pry(main)> A.a
NoMethodError: undefined method `with_retry' for A:Class
from (pry):4:in `a'

[1] pry(main)> class A
[1] pry(main)*   include ::Utils::Retryable
[1] pry(main)*   def a
[1] pry(main)*     with_retry do
[1] pry(main)*       p 'test'
[1] pry(main)*       fail(StandardError, 'test')
[1] pry(main)*     end
[1] pry(main)*   end
[1] pry(main)* end
=> :a
[2] pry(main)> A.new.a
"test"
"test"
"test"
StandardError: test
from (pry):6:in `block in a'
```

## mix-inで引き継いだクラスメソッドも使用できない 上記の逆
### どうしてもクラスメソッドをmix-inで使いたい場合
- [Railsのclass_methods](https://qiita.com/Muruso/items/292c81e1ed91bf1e988b)
```
module log
  extend ActiveSupport::Concern

  def logger
    @logger ||= ::Utils::Logger
  end

  def logger=(new_logger)
    @logger = new_logger
  end

  class_methods do
    def logger
      @logger ||= ::Utils::Logger
    end

    def logger=(new_loger)
      @logger = new_loger
    end
  end
end
```
- extend ActiveSupport::Concern を追加
- 引き継ぎたいメソッドをclass_methodsで囲う
