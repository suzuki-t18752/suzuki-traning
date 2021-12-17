## [rails、slack api用ライブラリ](https://github.com/slack-ruby/slack-ruby-client)
### slackへメッセージの送信テストを行う
1. [slack api](https://api.slack.com/)にアクセスし「your apps」を押下し[apisa作成ページ](https://api.slack.com/apps)を開く
2. 「create new app」→ 「From scratch」を押下
3. App Nameに適当な名前、「Pick a workspace to develop your app in:」でapi連携したワークスペースを選択
4. 「create app」を選択でapi連携用のアプリが作成される
5. 左のリスト内「features」の「OAuth & Permissions」を選択
6. 「Scopes」欄「Bot Token Scopes」の「add an OAuth scope」を押下
7. 「chat:write.customize」と「chat:write.public」を選択
8. 「Scopes」欄「User Token Scopes」の「add an OAuth scope」を押下
9. 「chat:write」と「users:read」を選択
10. 「OAuth Tokens for Your Workspace」欄の「install to workspace」を押下
11. slackアプリにてapiを許可するかどうかでるので許可するを押下
12. 「Bot User OAuth Token」「User OAuth Token」が作成されるのでメモする
13. [ユーザーデータ確認テストページ](https://api.slack.com/methods/users.list/test)にアクセスする
14. 「Tester」タブを押下し、「Arguments」欄の「Or, provide your own token:」に10でメモしたUser OAuth Tokenを入力する
15. 「Test method」を押下する
16. 「API response」欄にてテスト送信を行いたいユーザーのid("id": "~~~~~")をメモする
17. 下記テストコードを使う

- テストコード
```
def post_message(message, channel, id, name)
    slack_web_client.chat_postMessage(
        channel: channel,
        blocks: build_blocks(message, id, name),
    )
end

def slack_web_client
    ::Slack::Web::Client.new(token: '12でメモしたBot User OAuth Tokenを使う')
end

def build_banner(id, name)
    banner_elements = ["hostname:test"]
    banner_elements << "店舗ID:#{id}" if id
    banner_elements << "店舗名:#{name}" if name
    banner_elements.join(' ')
end

def build_blocks(message, id, name)
    [
        {
            type: 'context',
            elements: [
            { type: 'plain_text', text: build_banner(id, name) },
            ],
        },
        {
            type: 'section',
            text: { type: 'mrkdwn', text: message },
        },
    ]
end

edit_url = 'https://test'
msg = <<~MSG
    test____suzukit
    %<edit_url>s
MSG

message = format(msg, edit_url: edit_url)
channel = '16でメモしたidを使う'
id = 1
name = 'suzukit-test'

#::Utils::Slack.
post_message(message, channel, id, name)
```
