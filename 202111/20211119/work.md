## target="blank"
- セキュリティ上の問題
  - 親ページのプロセスと子ページ(別タブ)が同じプロセスで実行される場合があり、子ページにて重たいjavascriptが実行される場合、親ページにも不可がかかる
  - window.openerを使用することで、親ウィンドウのオブジェクトにアクセスを行ったり、window.opener.location = newURL によって親ページのURLを書き換えられる危険性がある
- 対策
  - noopenerを指定する
    - リンク先からwindow.openerを使ってリンク元が参照できなり、リンク先とリンク元が別のものとして扱われるためパフォーマンスに対しての対策にもなっている
  - noreffererを指定する
    - ブラウザによっては、noopenerがサポートされていないため、noopenerと合わせてnoreffererを指定するのが好ましい、noreffererを指定することで、リンク先にリンク元のリンク情報が送られないようになるため、 noopenerと同じくリンク先からの参照ができなくなる
```
#rails
<%= link_to contact.name, admin_path(contact.name_id), target: :_blank, rel: "noopener noreferrer" %>
#html
<a href="ここにリンク先のURLを入れる" target="_blank" rel="noopener noreferrer">新規タブで開く</a>
```

## slackへメッセージを送信する
- [slack-notifier](https://github.com/slack-notifier/slack-notifier)
- [参考](https://qiita.com/suusan2go/items/967da1bb0e138dd30e0e)


テストコード
```
edit_url = 'https://www.google.com/'
msg = <<~MSG
test____
%<edit_url>s
MSG
message = format(msg, edit_url: edit_url)

def build_blocks(message, id, name)
[
    {
    type: 'context',
    elements: [
        { type: 'plain_text', text: 'test' },
    ],
    },
    {
    type: 'section',
    text: { type: 'mrkdwn', text: message },
    },
]
end

 ###事前準備で取得したWebhook URL
notifier = Slack::Notifier.new('https://hooks.slack.com/services/njdfhdkjfhsfjkahfa/jfbjkfasbkf')
notifier.ping(blocks: build_blocks(message, 1000, 'test_name'))
```


# yumパッケージでの環境構築(apache→nginx,mod-php→php-fpm)
## virtualboxのインストール

[インストール元](https://www.virtualbox.org/wiki/Downloads)

### CPUの仮想化が出来ているか確認
- 再起動して立ち上がり時にF2を入力続けてBIOSを開く
- Advanced
  - Advanced Chipset Control
  - Intel Virtualization TechnologyをEnabledに変更

### virtualbox仮想マシン設定
- virtualboxの立ち上げ
  - 新規作成
  - 下記設定を順番に入力していく
    - 名前: centOS7
    - バージョン：red hat 64bit(red hat社の提供するディストリビューション)
    - メモリ：4G
    - ファイルタイプ：VDI(virtualboxの基本的ファイルタイプ)
    - ストレージサイズ設定：可変サイズ(使用した分だけ物理ハードディスク領域を使用)
    - ストレージサイズ：40G

## linuxのインストール

[インストール元](https://www.centos.org/download/)

### centOSダウンロード
- インストール元を開く
  - 7のタブを選択
  - x86_64をクリック
  - ISO images available内の好きなリンクを選択
  - DVD ISOを選択しダウンロード

## centOSの設定方法
- virtualboxの立ち上げ後、起動ボタンを押下
  - デバイス内の光学ドライブ、ディスクファイルの選択を押下
  - ダウンロードしたISOファイル(centOS~~~)を選択
  -　virtualboxの再起動を行う
  -　インストール先を選択
  -　インストール開始を選択
  - ユーザーの設定を行う(rootユーザーのパスワードを設定)
  - 設定完了を押下
  - 再起動を押下

## ユーザーの作成
```

[root@localhost ~]# useradd suzuki
useradd: ユーザ 'suzuki' は既に存在します
[root@localhost ~]# passwd suzuki0901
passwd: 不明なユーザー名 'suzuki0901'。
[root@localhost ~]# passwd suzuki
ユーザー suzuki のパスワードを変更。
新しいパスワード:
新しいパスワードを再入力してください:
passwd: すべての認証トークンが正しく更新できました。
[root@localhost ~]# usermod -aG wheel suzuki

```


## virtualboxのネットワーク接続設定

[ネットワーク設定の詳細](https://www.it-poem.com/?p=310)

1. virtualbox、ツールの横にある横線3つのボタンを選択し、ネットワークを開き、ipv4のアドレス(ホストOSのアドレス)を確認する

2. 作成したOSの設定ボタンを押下すると、設定画面が開くのでネットワークを押下してアダプター1の割り当てがNATになっていることを確認する。なっていない場合は変更する

3. アダプター2の設定を変更する
- ネットワークの有効化:チェックを入れる
- 割り当て:ホストオンリーアダプター

4. OSを起動後、コマンドを実行し、設定画面を開く
```
[suzuki@localhost ~]$ nmtui
```
5. Edit a connection → enp0s3の順にenterキーで選択

6. IPv6の部分をenterで選択後、プルダウンが表示されるのでIgnoreを選択する

7. Automatically connectにspaceキーでバツマークを入れてから、OKをenterキーで選択し完了する

8. enp0s3の上(文字化けしている □□□)にカーソルを合わせてenterキーで選択する

9. nameをenp0s8に変更し、IPv4の部分をenterで選択後、プルダウンが表示されるのでManualを選択し、showボタンを押下する

10. Addressをenterキーで選択し、1で確認したipアドレスを下限、ネットマスクを上限の範囲として適当に決めて入力します

11. 6,7と同じようにIPv6とAutomatically connectを設定し、完了する

12. Back → Quitの順で選択し、OS起動画面に戻る


## 細かい設定
```
[root@localhost ~]# hostnamectl set-hostname suzuki-t
[root@localhost ~]# hostnamectl status
   Static hostname: suzuki-t
         Icon name: computer-vm
           Chassis: vm
        Machine ID: ~~~~~
           Boot ID: =====
    Virtualization: kvm
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-1160.el7.x86_64
      Architecture: x86-64
[root@localhost ~]# cp /etc/hosts /etc/hosts_bak
[root@localhost ~]# sh -c "echo '192.168.56.3   suzuki-t.com' >> /etc/hosts"
[root@localhost ~]# sh -c "echo '192.168.56.3   suzuki-t.net' >> /etc/hosts"
[root@localhost ~]# diff /etc/hosts /etc/hosts_bak
3,4d2
< 192.168.56.3   suzuki-t.com
< 192.168.56.3   suzuki-t.net
```

## iptablesの設定
```
#yumアップデート
[suzuki@suzuki-t ~]$ yum -y update

#iptablesインストール確認
[suzuki@suzuki-t ~]$ which iptabels
/usr/bin/which: no iptabels in (/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/suzuki/.local/bin:/home/suzuki/bin)


#firefalldの確認と停止
[suzuki@suzuki-t ~]$ systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; enabled; vendor preset: enabled)
   Active: active (running) since 金 2021-11-19 18:29:09 JST; 6min ago
     Docs: man:firewalld(1)
 Main PID: 16628 (firewalld)
   CGroup: /system.slice/firewalld.service
           └─16628 /usr/bin/python2 -Es /usr/sbin/firewalld --nofork --nopid

11月 19 18:29:09 suzuki-t systemd[1]: Stopped firewalld - dynamic firewall daemon.
11月 19 18:29:09 suzuki-t systemd[1]: Starting firewalld - dynamic firewall daemon...
11月 19 18:29:09 suzuki-t systemd[1]: Started firewalld - dynamic firewall daemon.
11月 19 18:29:09 suzuki-t firewalld[16628]: WARNING: AllowZoneDrifting is enabled. This is considered an insecure configuration option. It will be removed in a future release. Please consider disabling it now.
Hint: Some lines were ellipsized, use -l to show in full.
[suzuki@suzuki-t ~]$ systemctl is-enabled firewalld
enabled

[suzuki@suzuki-t ~]$ systemctl stop firewalld
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to manage system services or units.
Authenticating as: suzuki
Password:
==== AUTHENTICATION COMPLETE ===
[suzuki@suzuki-t ~]$ systemctl disable firewalld
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-unit-files ===
Authentication is required to manage system service or unit files.
Authenticating as: suzuki
Password:
==== AUTHENTICATION COMPLETE ===
Removed symlink /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
==== AUTHENTICATING FOR org.freedesktop.systemd1.reload-daemon ===
Authentication is required to reload the systemd state.
Authenticating as: suzuki
Password:
==== AUTHENTICATION COMPLETE ===
[suzuki@suzuki-t ~]$ systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:firewalld(1)

11月 19 17:55:39 localhost.localdomain systemd[1]: Starting firewalld - dynamic firewall daemon...
11月 19 17:55:40 localhost.localdomain systemd[1]: Started firewalld - dynamic firewall daemon.
11月 19 17:55:41 localhost.localdomain firewalld[663]: WARNING: AllowZoneDrifting is enabled. This is considered an insecure configuration option. It will be removed in a future release. Please ...bling it now.
11月 19 18:29:06 suzuki-t systemd[1]: Stopping firewalld - dynamic firewall daemon...
11月 19 18:29:09 suzuki-t systemd[1]: Stopped firewalld - dynamic firewall daemon.
11月 19 18:29:09 suzuki-t systemd[1]: Starting firewalld - dynamic firewall daemon...
11月 19 18:29:09 suzuki-t systemd[1]: Started firewalld - dynamic firewall daemon.
11月 19 18:29:09 suzuki-t firewalld[16628]: WARNING: AllowZoneDrifting is enabled. This is considered an insecure configuration option. It will be removed in a future release. Please consider disabling it now.
11月 19 18:37:37 suzuki-t systemd[1]: Stopping firewalld - dynamic firewall daemon...
11月 19 18:37:41 suzuki-t systemd[1]: Stopped firewalld - dynamic firewall daemon.
Hint: Some lines were ellipsized, use -l to show in full.
[suzuki@suzuki-t ~]$ systemctl is-enabled firewalld
disabled

# iptablesのインストール
[suzuki@suzuki-t ~]$ sudo yum install iptables-services
読み込んだプラグイン:fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.riken.jp
 * extras: ftp.riken.jp
 * updates: ftp.riken.jp
依存性の解決をしています
--> トランザクションの確認を実行しています。
---> パッケージ iptables-services.x86_64 0:1.4.21-35.el7 を インストール
--> 依存性解決を終了しました。

依存性を解決しました

===================================================================================================================================================================================================================
 Package                                                   アーキテクチャー                               バージョン                                            リポジトリー                                  容量
===================================================================================================================================================================================================================
インストール中:
 iptables-services                                         x86_64                                         1.4.21-35.el7                                         base                                          52 k

トランザクションの要約
===================================================================================================================================================================================================================
インストール  1 パッケージ

総ダウンロード容量: 52 k
インストール容量: 23 k
Is this ok [y/d/N]: y
Downloading packages:
iptables-services-1.4.21-35.el7.x86_64.rpm                                                                                                                                                  |  52 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  インストール中          : iptables-services-1.4.21-35.el7.x86_64                                                                                                                                             1/1
  検証中                  : iptables-services-1.4.21-35.el7.x86_64                                                                                                                                             1/1

インストール:
  iptables-services.x86_64 0:1.4.21-35.el7

完了しました!

#iptables確認
[suzuki@suzuki-t ~]$ yum list installed | grep iptables
iptables.x86_64                       1.4.21-35.el7                    @anaconda
iptables-services.x86_64              1.4.21-35.el7                    @base

[suzuki@suzuki-t ~]$ systemctl status iptables
● iptables.service - IPv4 firewall with iptables
   Loaded: loaded (/usr/lib/systemd/system/iptables.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
[suzuki@suzuki-t ~]$ systemctl is-enabled iptables
disabled

#iptables起動と確認
[suzuki@suzuki-t ~]$ systemctl start iptables
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to manage system services or units.
Authenticating as: suzuki
Password:
==== AUTHENTICATION COMPLETE ===
[suzuki@suzuki-t ~]$ systemctl enable iptables
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-unit-files ===
Authentication is required to manage system service or unit files.
Authenticating as: suzuki
Password:
==== AUTHENTICATION COMPLETE ===
Created symlink from /etc/systemd/system/basic.target.wants/iptables.service to /usr/lib/systemd/system/iptables.service.
==== AUTHENTICATING FOR org.freedesktop.systemd1.reload-daemon ===
Authentication is required to reload the systemd state.
Authenticating as: suzuki
Password:
==== AUTHENTICATION COMPLETE ===
[suzuki@suzuki-t ~]$ systemctl status iptables
● iptables.service - IPv4 firewall with iptables
   Loaded: loaded (/usr/lib/systemd/system/iptables.service; enabled; vendor preset: disabled)
   Active: active (exited) since 金 2021-11-19 18:44:27 JST; 19s ago
 Main PID: 25270 (code=exited, status=0/SUCCESS)

11月 19 18:44:27 suzuki-t systemd[1]: Starting IPv4 firewall with iptables...
11月 19 18:44:27 suzuki-t iptables.init[25270]: iptables: Applying firewall rules: [  OK  ]
11月 19 18:44:27 suzuki-t systemd[1]: Started IPv4 firewall with iptables.
[suzuki@suzuki-t ~]$ systemctl is-enabled iptables
enabled

[suzuki@suzuki-t ~]$ sudo iptables -nL
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0            state RELATED,ESTABLISHED
ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0            state NEW tcp dpt:22
REJECT     all  --  0.0.0.0/0            0.0.0.0/0            reject-with icmp-host-prohibited

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
REJECT     all  --  0.0.0.0/0            0.0.0.0/0            reject-with icmp-host-prohibited

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

#ルールの追加
[suzuki@suzuki-t ~]$ iptables -I INPUT 5 -p tcp --dport 80 -j ACCEPT
iptables v1.4.21: can't initialize iptables table `filter': Permission denied (you must be root)
Perhaps iptables or your kernel needs to be upgraded.
[suzuki@suzuki-t ~]$ iptables -I INPUT 5 -p tcp --dport 443 -j ACCEPT
iptables v1.4.21: can't initialize iptables table `filter': Permission denied (you must be root)
Perhaps iptables or your kernel needs to be upgraded.
[suzuki@suzuki-t ~]$ iptables -I INPUT 5 -p tcp --dport 3306 -j ACCEPT
iptables v1.4.21: can't initialize iptables table `filter': Permission denied (you must be root)
Perhaps iptables or your kernel needs to be upgraded.
[suzuki@suzuki-t ~]$ iptables -I INPUT 5 -p tcp --dport 3307 -j ACCEPT
iptables v1.4.21: can't initialize iptables table `filter': Permission denied (you must be root)
Perhaps iptables or your kernel needs to be upgraded.
[suzuki@suzuki-t ~]$ sudo iptables -I INPUT 5 -p tcp --dport 80 -j ACCEPT
[suzuki@suzuki-t ~]$ sudo iptables -I INPUT 5 -p tcp --dport 443 -j ACCEPT
[suzuki@suzuki-t ~]$ sudo iptables -I INPUT 5 -p tcp --dport 3306 -j ACCEPT
[suzuki@suzuki-t ~]$ sudo iptables -I INPUT 5 -p tcp --dport 3307 -j ACCEPT
[suzuki@suzuki-t ~]$ iptables -nL
iptables v1.4.21: can't initialize iptables table `filter': Permission denied (you must be root)
Perhaps iptables or your kernel needs to be upgraded.
[suzuki@suzuki-t ~]$ sudo iptables -nL
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0            state RELATED,ESTABLISHED
ACCEPT     icmp --  0.0.0.0/0            0.0.0.0/0
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0            state NEW tcp dpt:22
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:3307
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:3306
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:443
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0            tcp dpt:80
REJECT     all  --  0.0.0.0/0            0.0.0.0/0            reject-with icmp-host-prohibited

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
REJECT     all  --  0.0.0.0/0            0.0.0.0/0            reject-with icmp-host-prohibited

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
