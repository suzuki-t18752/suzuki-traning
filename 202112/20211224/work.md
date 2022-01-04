# Mechanize
- rubyのライブラリ
- スクレイピングが出来る

```
[1] pry(main)> agent = Mechanize.new
=> #<Mechanize
 #<Mechanize::CookieJar:0x000055fc80549de0
  @store=
   #<HTTP::CookieJar::HashStore:0x000055fc805b7228
    @gc_index=0,
    @gc_threshold=150,
    @jar={},
    @logger=nil,
    @mon_count=0,
    @mon_mutex=#<Thread::Mutex:0x000055fc805b7160>,
    @mon_mutex_owner_object_id=47271486798100,
    @mon_owner=nil>>
 nil>
[2] pry(main)> page = agent.get("https://board-t18752.herokuapp.com/")
=> #<Mechanize::Page
 {url #<URI::HTTPS https://board-t18752.herokuapp.com/>}
 {meta_refresh}
 {title "掲示板"}
 {iframes}
 {frames}
 {links #<Mechanize::Page::Link "はじめての方はこちらから登録を" "view/entry/registration_mail_form.php">}
 {forms
  #<Mechanize::Form
   {name nil}
   {method "POST"}
   {action "index.php"}
   {fields [text:0x2afe403d99d8 type: text name: user_id value: ] [field:0x2afe403d9758 type: password name: password value: ]}
   {radiobuttons}
   {checkboxes}
   {file_uploads}
   {buttons [submit:0x2afe403d9514 type: submit name: login value: ログイン]}>}>
[3] pry(main)> elements = page.at('body')
=> #(Element:0x2afe4045568c {
  name = "body",
  children = [
    #(Text "\r\n        "),
    #(Element:0x2afe404545fc { name = "header", attributes = [ #(Attr:0x2afe4045cdb0 { name = "class", value = "in_icon" })], children = [ #(Text "BOARD")] }),
    #(Text "\r\n"),
    #(Element:0x2afe404545d4 {
```

- agent = Mechanize.new
  - Mechanizeを使用する為にインスタンス化
- agent.get("https://board-t18752.herokuapp.com/")
  - 指定したURLのページを取得
- .at('body')
  - atで要素を取得
- .search
  - 要素の検索
```
[4] pry(main)> page.search('form')
=> [#<Nokogiri::XML::Element:0x2afe403d46b8 name="form" attributes=[#<Nokogiri::XML::Attr:0x2afe404aaab0 name="action" value="index.php">, #<Nokogiri::XML::Attr:0x2afe404aaa88 name="method" value="POST">] children=[#<Nokogiri::XML::Text:0x2afe404aaa24 "\r\n    ">, #<Nokogiri::XML::Element:0x2afe404aaa10 name="p" children=[#<Nokogiri::XML::Text:0x2afe404d57b0 "ログインID：">, #<Nokogiri::XML::Element:0x2afe404d579c name="br">, #<Nokogiri::XML::Element:0x2afe403d9ba4 name="input" attributes=[#<Nokogiri::XML::Attr:0x2afe404df940 name="type" value="text">, #<Nokogiri::XML::Attr:0x2afe404df92c name="name" value="user_id">]>]>, #<Nokogiri::XML::Text:0x2afe404aa9d4 "\r\n    ">, #<Nokogiri::XML::Element:0x2afe404aa998 name="p" children=[#<Nokogiri::XML::Text:0x2afe40502f44 "パスワード：">, #<Nokogiri::XML::Element:0x2afe40502f1c name="br">, #<Nokogiri::XML::Element:0x2afe403d9b90 name="input" attributes=[#<Nokogiri::XML::Attr:0x2afe40526ea8 name="type" value="password">, #<Nokogiri::XML::Attr:0x2afe40526e94 name="name" value="password">]>]>, #<Nokogiri::XML::Text:0x2afe404aa95c "\r\n    ">, #<Nokogiri::XML::Element:0x2afe403d9b68 name="input" attributes=[#<Nokogiri::XML::Attr:0x2afe4054ddb4 name="type" value="submit">, #<Nokogiri::XML::Attr:0x2afe4054dd8c name="class" value="form_btn">, #<Nokogiri::XML::Attr:0x2afe4054dd78 name="name" value="login">, #<Nokogiri::XML::Attr:0x2afe4054dd50 name="value" value="ログイン">]>, #<Nokogiri::XML::Text:0x2afe404aa920 "\r\n  ">]>]
```
- .links
  - リンクを取得
```
[5] pry(main)> page.links
=> [#<Mechanize::Page::Link "はじめての方はこちらから登録を" "view/entry/registration_mail_form.php">]
```

- .link_with(text: 'クリックしたいページへのリンクテキスト').click
  - リンク先へとぶ
  - .link_with(href: 'クリックしたいページへのリンクURL')
```
[9] pry(main)> link_page = page.link_with(text: 'はじめての方はこちらから登録を').click
=> #<Mechanize::Page
 {url #<URI::HTTPS https://board-t18752.herokuapp.com/view/entry/registration_mail_form.php>}
 {meta_refresh}
 {title "メール登録画面"}
 {iframes}
 {frames}
 {links}
 {forms
  #<Mechanize::Form
   {name nil}
   {method "POST"}
   {action "registration_mail_check.php"}
   {fields [text:0x2afe40c257a4 type: text name: mail value: ] [hidden:0x2afe40c25614 type: hidden name: token value: H39uDNAyuOg63icCJx9AwSXeARaDXal6X1c/d3quf2M=]}
   {radiobuttons}
   {checkboxes}
   {file_uploads}
   {buttons [submit:0x2afe40c25ba0 type: submit name:  value: YES] [button:0x2afe40c25a10 type: button name:  value: NO] [button:0x2afe40c25358 type: button name:  value: 登録する]}>}>
```

- .forms
  - フォームを一覧表示
[11] pry(main)> page.forms
=> [#<Mechanize::Form
  {name nil}
  {method "POST"}
  {action "index.php"}
  {fields [text:0x2afe403d99d8 type: text name: user_id value: ] [field:0x2afe403d9758 type: password name: password value: ]}
  {radiobuttons}
  {checkboxes}
  {file_uploads}
  {buttons [submit:0x2afe403d9514 type: submit name: login value: ログイン]}>]
```



- .field_with(name: 'フォームのname').value = 'フォームに入力する値'
  - フォームに値を入力
- agent.submit(login_form, login_form.buttons.first)
  - フォームをpostする
```
[18] pry(main)> login_form = result_form.forms[0]
=> #<Mechanize::Form
 {name nil}
 {method "POST"}
 {action "index.php"}
 {fields [text:0x2b1f55757854 type: text name: user_id value: ] [field:0x2b1f55757700 type: password name: password value: ]}
 {radiobuttons}
 {checkboxes}
 {file_uploads}
 {buttons [submit:0x2b1f557575d4 type: submit name: login value: ログイン]}>
[19] pry(main)> login_form.field_with(name: 'user_id').value = '211934195'
=> "211934195"
[20] pry(main)> login_form.field_with(name: 'password').value = 'test0000'
=> "test0000"
[22] pry(main)> result_page = agent.submit(login_form, login_form.buttons.first)
=> #<Mechanize::Page
 {url #<URI::HTTPS https://board-t18752.herokuapp.com/index.php>}
 {meta_refresh}
 {title "掲示板"}
 {iframes}
 {frames}
 {links
  #<Mechanize::Page::Link "BOARD" "index.php">
  #<Mechanize::Page::Link "記事の投稿" "view/new_article.php">
  #<Mechanize::Page::Link "ユーザー登録の編集" "view/user.php">
  #<Mechanize::Page::Link "ログアウト" "index.php?btn_logout=ログアウト">
  #<Mechanize::Page::Link "記事の投稿" "view/new_article.php">
  #<Mechanize::Page::Link "ユーザー登録の編集" "view/user.php">
  #<Mechanize::Page::Link "ログアウト" "index.php?btn_logout=ログアウト">
  #<Mechanize::Page::Link "記事詳細" "view/show_article.php?id=5ef71d7ded19e">
  #<Mechanize::Page::Link "記事詳細" "view/show_article.php?id=5ef73c9d3cc0c">
  #<Mechanize::Page::Link "記事詳細" "view/show_article.php?id=5efa99feed81c">
  #<Mechanize::Page::Link "記事詳細" "view/show_article.php?id=60de919ef12fa">}
 {forms
  #<Mechanize::Form
   {name nil}
   {method "POST"}
   {action "index.php"}
   {fields [text:0x2b1f56382b38 type: text name: title value: ] [field:0x2b1f563829e4 type: date name: date value: ]}
   {radiobuttons}
   {checkboxes}
   {file_uploads}
   {buttons [submit:0x2b1f563828b8 type: submit name: search_article value: 検索]}>}>
```


- login_page.at('form').attributes
  - 要素のidやclassを取得
```
[17] pry(main)> login_page.at('form').attributes
=> {"class"=>#(Attr:0x2b2612e493d8 { name = "class", value = "new_admin_user" }),
 "id"=>#(Attr:0x2b2612e4939c { name = "id", value = "new_admin_user" }),
 "action"=>#(Attr:0x2b2612e49360 { name = "action", value = "/admin/users/sign_in" }),
 "accept-charset"=>#(Attr:0x2b2612e4934c { name = "accept-charset", value = "UTF-8" }),
 "method"=>#(Attr:0x2b2612e49338 { name = "method", value = "post" })}
[18] pry(main)> login_page.at('form').attributes['id']
=> #(Attr:0x2b2612e4939c { name = "id", value = "new_admin_user" })
[19] pry(main)> login_page.at('form').attributes['id'].value
=> "new_admin_user"
[20] pry(main)> form_id = login_page.at('form').attributes['id'].value
=> "new_admin_user"
[21] pry(main)> login_form = login_page.form_with(id: form_id)
=> #<Mechanize::Form
 {name nil}
 {method "POST"}
 {action "/sign_in"}
 {fields
  [field:0x2b2612d29160 type: email name: admin_user[email] value: ]
  [field:0x2b2612d28f30 type: password name: admin_user[password] value: ]}
 {radiobuttons}
 {checkboxes}
 {file_uploads}
 {buttons [submit:0x2b2612d28d8c type: submit name: commit value: ログイン]}>
```
