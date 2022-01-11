## [Dry-rbライブラリ](https://dry-rb.org/)
- active_modelとは別にクラスオブジェクトを作成することが出来る
```
module Types
  include ::Dry.Types
end

class Argument < Dry::Struct
  attribute :site_id, Types::Integer.optional.default(nil)
  attribute :site_code, Types::String.optional.default(nil)
  attribute :site_name, Types::String.optional.default(nil)
  attribute :login_url, Types::String.optional.default(nil)
end
```
- 使い方
  - module Typesにinclude ::Dry.Typesを入れる
  - attributeで属性(持たせたい値)を設定
  - typesで型を設定
  - .optionalでnilを許容する
  - defaultを設定しないと必ず値を入れる必要がある(下記エラーが出る)
```
[2] pry(main)> Argument.new
Dry::Struct::Error: [Argument.new] :site_id is missing in Hash input
from lib/dry/types/schema.rb:384:in `block in resolve_missing_keys'
```
- ? を指定することで属性をしていしなくてもよくなる(.default(nil)と同じ動作)
- https://dry-rb.org/gems/dry-types/1.2/hash-schemas/
```
class Argument < BaseValue
  transform_keys(&:to_sym)
  attribute? :site_id, Types::Integer

OR

class Argument < BaseValue
  attribute :site_id?, Types::Integer.optional
```


- 結果
```
[4] pry(main)> Argument.new
=> #<Argument site_id=nil site_code=nil site_name=nil login_url=nil>
[5] pry(main)> Argument.new.site_id
=> nil
```

- factorybot
```
# frozen_string_literal: true
FactoryBot.define do
  factory :argument, class: 'Argument' do
    initialize_with  { new(attributes) }
    skip_create

    site_id { nil }
    site_code { nil }
    site_name { nil }
    login_url { nil }
  end
end
```
  - initialize_with  { new(attributes) }
  - 上記を入れないと下記エラーが発生する
  - Argument.newをした時と同じ動作をする(default値が設定されるよ)
```
Failure/Error:
       build(
         :argument,
         site_id: site_id,
         site_code: site_code,
         site_name: site_name,
         login_url: login_url,
       )

     NoMethodError:
       undefined method `site_id=' for #<Argument:0x000055849918d8c8>
     # ./spec/serializers/argument_serializer_spec.rb:8:in `block (2 levels) in <top (required)>'
     # ./spec/serializers/argument_serializer_spec.rb:59:in `block (3 levels) in <top (required)>'
```
