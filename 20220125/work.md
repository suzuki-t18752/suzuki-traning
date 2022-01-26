## クラスメソッドはmix-inで引き継いだメソッドを使用出来ない！！！！！！
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
