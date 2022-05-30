## ruby Hash has_key?,key?,include?,member?
- ハッシュに引数のキーが存在するか確認する
- ある場合にtrue,ない場合false

```
[8] pry(main)> {'test' => 1, 'test2' => 2}.key?('test2')
=> true
[9] pry(main)> {'test' => 1, 'test2' => 2}.include?('test2')
=> true
[10] pry(main)> {'test' => 1, 'test2' => 2}.include?('test')
=> true
[11] pry(main)> {'test' => 1, 'test2' => 2}.has_key?('test')
=> true
[12] pry(main)> {'test' => 1, 'test2' => 2}.has_key?('test2')
=> true
[13] pry(main)> {'test' => 1, 'test2' => 2}.has_key?('test3')
=> false
[14] pry(main)> {'test' => 1, 'test2' => 2}.include?('test3')
=> false
```

## ruby Hash has_value?,value?
- ハッシュに引数の値が存在するか確認する
- ある場合にtrue,ない場合false


### どれが推奨なのか？
- rubocopだとkey?がデフォルトで推奨されている
```
module RuboCop
  module Cop
    module Style
      # This cop checks for uses of methods `Hash#has_key?` and
      # `Hash#has_value?`, and suggests using `Hash#key?` and `Hash#value?` instead.
      #
      # It is configurable to enforce the verbose method names, by using the
      # `EnforcedStyle: verbose` configuration.
      #
      # @safety
      #   This cop is unsafe because it cannot be guaranteed that the receiver
      #   is a `Hash` or responds to the replacement methods.
      #
      # @example EnforcedStyle: short (default)
      #  # bad
      #  Hash#has_key?
      #  Hash#has_value?
      #
      #  # good
      #  Hash#key?
      #  Hash#value?
      #
      # @example EnforcedStyle: verbose
      #  # bad
      #  Hash#key?
      #  Hash#value?
      #
      #  # good
      #  Hash#has_key?
      #  Hash#has_value?
```

- include?のaliasとして定義されているよう
```
https://github.com/ruby/ruby/blob/2a76440fac62bb0f6e53ccada07caf4b47b78cf9/hash.c

/*
 *  call-seq:
 *    hash.include?(key) -> true or false
 *    hash.has_key?(key) -> true or false
 *    hash.key?(key) -> true or false
 *    hash.member?(key) -> true or false
 *  Methods #has_key?, #key?, and #member? are aliases for \#include?.
 *
 *  Returns +true+ if +key+ is a key in +self+, otherwise +false+.
 */
MJIT_FUNC_EXPORTED VALUE
rb_hash_has_key(VALUE hash, VALUE key)
{
    return RBOOL(hash_stlike_lookup(hash, key, NULL));
}



rb_define_method(rb_cHash, "include?", rb_hash_has_key, 1);
rb_define_method(rb_cHash, "member?", rb_hash_has_key, 1);
rb_define_method(rb_cHash, "has_key?", rb_hash_has_key, 1);
rb_define_method(rb_cHash, "has_value?", rb_hash_has_value, 1);
rb_define_method(rb_cHash, "key?", rb_hash_has_key, 1);
rb_define_method(rb_cHash, "value?", rb_hash_has_value, 1);

```

- ちらっと下記の記事をみてなにをしているのかinclude?だと分かりにくい
https://muramurasan.hatenablog.jp/entry/2015/11/06/000926
- keyがあるのか、valueがあるのか、どっちを探しているのか分かりにくい気がする
- もちろんrubyの知識があり、Hashクラスにinclude?を使っているならkeyを探していると分かるがぱっとっみkey?の方が分かりやすい
- なんならhas_keyが一番分かりやすい、個人的に

- なのでkey?を使っていこうと思う


## ruby 読みやすい書き方について
- https://yokonoji.work/ruby-beautiful-code-layout#outline__1_8
