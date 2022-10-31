# 0.virtualboxのネットワーク接続設定

[ネットワーク設定の詳細](https://www.it-poem.com/?p=310)

- ホストOS  
VirtualBoxを起動しているOS

- ゲストOS  
VirtualBoxで起動しているOS

- NAT  
ゲストOSから外部のネットワークに対してはアクセスすることが出来るが、ホストOSを含めた外部からはアクセスすることが出来ない設定

- ホストオンリーアダプター
ゲストOSに対して、ホストOSのみがアクセス出来、ゲストOSは他へアクセスすることの出来ない設定

1. virtualbox、ツールの横にある横線3つのボタンを選択し、ネットワークを開き、ipv4のアドレスを確認する

![](./virtualboxネットワーク接続1.png)
![](./virtualboxネットワーク接続2.png)

2. 作成したOSの設定ボタンを押下すると、設定画面が開くのでネットワークを押下してアダプター1の割り当てがNATになっていることを確認する。なっていない場合は変更する
![](./画面1.png)
![](./画面2.png)

3. アダプター2の設定を変更する
- ネットワークの有効化:チェックを入れる
- 割り当て:ホストオンリーアダプター

![](./画面3.png)

4. OSを起動後、'nmtui'コマンドを実行し、下記画面を開く

![](./画面4.png)

5. Edit a connection → enp0s3の順にenterキーで選択

[ネットワーク名enp~~~について](https://qiita.com/fetaro/items/b61282130fa638de4528)  

![](./画面5.png)

6. IPv6の部分をenterで選択後、プルダウンが表示されるのでIgnoreを選択する。

7. Automatically connectにspaceキーでバツマークを入れてから、OKをenterキーで選択し完了する
![](./画面6.png)

8. 5の画面が表示されるので、enp0s3の上にカーソルを合わせてenterキーで選択する

9. nameをenp0s8に変更し、IPv4の部分をenterで選択後、プルダウンが表示されるのでManualを選択し、showボタンを押下する。

![](./画面7.png)

10. Addressをenterキーで選択し、1で確認したipアドレスを下限、ネットマスクを上限の範囲として適当に決めて入力します。  
192.168.56.1だったので192.168.56.2/24に設定。
![](./画面8.png)

11. 6,7と同じようにIPv6とAutomatically connectを設定し、完了する
![](./画面9.png)

12. Back → Quitの順で選択し、OS起動画面に戻る

13. 'systemctl restart NetworkManager'と'systemctl restart network'コマンドを実行し、設定を反映する。

[設定方法、概要](https://blog.proglus.jp/3315/)

# 1.ファイアウォールiptablesの設定

## ファイアウォール
### 概要
ネットワークの境界に設置され、外部から内部への通信をさせるかどうかを判断し許可するまたは拒否する仕組み

## iptables
### 概要
Linuxに実装されたパケットフィルタリング型のファイアウォール機能

### パケットフィルタリング
外部から受信したデータ(パケット)を管理者などが設定した一定の基準に従って通したり破棄したりする。  
プロトコル (TCPやUDP、ICMP等、送信元・送信先IPアドレス、送信元・送信先のポート番号を使って条件を設定し、パケットのフィルタリングをする。  

### firewalldとiptabels違い
firewalldはcentOS7にデフォルトで設定されているファイアウォール  
iptablesでは3つの情報を指定して条件を作りフィルタリングする。  
firewalldはiptablesよりも簡易的に設定ができるように「ゾーン」という設定のテンプレートが用意してある。  
簡単な設定で十分な場合はfirewalldを選択、より細かく設定したい場合はiptablesを選択。

### 設定
1. 'which iptabels'にてiptabelsがインストールされているか確認する  
(which コマンドの置かれているディレクトリを調べるコマンド)  

2. 'sudo yum update','sudo yum install iptables-services'にてiptabelsのインストールし、再度1を行いインストールされていることを確認する

### [※ネット接続設定に必須](https://qiita.com/ponsuke0531/items/e036dfa4dd1e69086e13)

- systemctlコマンド  
systemctlコマンドはsystemdを操作するコマンドで、サービスの起動や停止・起動設定の変更と状態確認ができる。

- systenmd  
systemdとはLinuxなどのUnix系のコンピューターのシステムを起動するときに様々なプログラムを動かす元のプログラム

3. 'systemctl status firewalld'と'systemctl is-enabled firewalld'にてfirewalldの状態を確認する 

![停止済み](./firewalld停止済み.png)

4. 'systemctl stop firewalld'と'systemctl disable firewalld'にてfirewalldのサービス停止と自動起動設定の停止、再度3を行い停止していることを確認する。

![停止実行](./firewalld停止.png)

5. 'systemctl status iptables'と'systemctl is-enabled iptables'にてiptablesの状態を確認する

![停止済み](./iptables停止済み.png)

6. 'systemctl start iptables'と'systemctl enable iptables'を行い、サービスの起動と自動起動設定の起動を行い、再度5を行い設定の確認を行う  
(iptablesの場合はactive(exited)の表示がされる、runningは常にアクセスを待ち構えている状態ですが、exitedはサービス起動時に呼び出され、次に呼び出されるまで待機している状態)

![起動済み](./iptables起動済み.png)

7. 'sudo iptables -nL'を実行し現在の設定内容を確認する

[設定内容参考](https://qiita.com/suin/items/5c4e21fa284497782f71)

8. 'sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT'と  
'sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT'を実行しルールを追加する

9. 'sudo iptables -D INPUT -j REJECT --reject-with icmp-host-prohibited'を実行し、ルールを削除する

10.  'sudo iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
'を実行し9で削除したルールを再び追加する

- 8~10まで
80/tcp, 443/tcp 宛の許可が評価されるより先に 9で削除するルールの｢ここまでの条
件にマッチしなかった場合には全て拒否｣というルールが評価され、8,9のルールを評価する前に拒否されてしまう為、9で削除を行い10で再度追加しています。

11. 'sudo /usr/libexec/iptables/iptables.init save'を実行し、変更したルールの保存を行う

[11のコマンドについて](https://qiita.com/takc923/items/782bf58b3dd8b7b452a3)

※コマンドで設定を行うよりも /etc/sysconfig/iptablesを直接編集し、12にて反映させる方法がcentOS7においては正解かもしれない

12. 'systemctl restart iptables'にてiptablesの再起動を行い、設定を適用する

13. 7を再度行い設定の反映を確認する

![設定反映後](./iptables設定反映後.png)

[参考](https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/6/html/security_guide/sect-security_guide-firewalls)


