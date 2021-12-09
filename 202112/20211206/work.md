## ruby
- select
  - 条件式がtrueの値を元の配列から取り出す
- map
  - 新しい配列として戻り値を返す
  - 値のないものはnilで返す


疑似アソシエーション
```
class Test
  def initialize
  end

  def name_id
    1
  end

  def name
    Name.new
  end

  class Name
    def initialize
    end

    def id
      1
    end
    def name
      '名前'
    end
  end
end

job = Test.new
controllers = []
p job.name_id
p job.name
p job.name.id
p job.name.name
```
