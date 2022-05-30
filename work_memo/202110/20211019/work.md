## apacheをsystedで管理
1. 設定ファイルの作成(別サーバーでyumにてhttpdをインストールしたファイルをコピー)
```
sudo vi /usr/lib/systemd/system/httpd.service
```
```
#設定内容
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/httpd
ExecStart=/usr/local/httpd/httpd-2.4.48/bin/apachectl start
ExecReload=/usr/local/httpd/httpd-2.4.48/bin/apachectl graceful
ExecStop=/usr/local/httpd/httpd-2.4.48/bin/apachectl stop
# We want systemd to give httpd some time to finish gracefully, but still want
# it to kill httpd after TimeoutStopSec if something went wrong during the
# graceful stop. Normally, Systemd sends SIGTERM signal right after the
# ExecStop, which would kill httpd. We are sending useless SIGCONT here to give
# httpd time to finish.
KillSignal=SIGCONT
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```
2. 起動設定
```
#


#起動
systemctl start httpd

動かない
↓
[suzuki@suzuki-t ~]$ systemctl status httpd.service
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: failed (Result: resources) since 火 2021-10-19 12:33:53 JST; 22min ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 2612 (code=exited, status=1/FAILURE)

10月 19 12:33:53 suzuki-t httpd[2612]: -T                 : start without DocumentRoot(s) check
10月 19 12:33:53 suzuki-t httpd[2612]: -X                 : debug mode (only one worker, do not detach)
10月 19 12:33:53 suzuki-t systemd[1]: httpd.service: main process exited, code=exited, status=1/FAILURE
10月 19 12:33:53 suzuki-t systemd[1]: Failed to start The Apache HTTP Server.
10月 19 12:33:53 suzuki-t systemd[1]: Unit httpd.service entered failed state.
10月 19 12:33:53 suzuki-t systemd[1]: httpd.service failed.
10月 19 12:56:25 suzuki-t systemd[1]: Failed to load environment files: No such file or directory
10月 19 12:56:25 suzuki-t systemd[1]: httpd.service failed to run 'start' task: No such file or directory
10月 19 12:56:25 suzuki-t systemd[1]: Failed to start The Apache HTTP Server.
10月 19 12:56:25 suzuki-t systemd[1]: httpd.service failed.

↓
#環境設定ファイルの作成(別サーバーでyumにてhttpdをインストールしファイル内を確認)
sudo touch /etc/sysconfig/httpd
↓

systemctl status httpd.service
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since 火 2021-10-19 12:33:53 JST; 7min ago
     Docs: man:httpd(8)
           man:apachectl(8)
 Main PID: 2612 (code=exited, status=1/FAILURE)

10月 19 12:33:53 suzuki-t httpd[2612]: -t -D DUMP_MODULES : show all loaded modules
10月 19 12:33:53 suzuki-t httpd[2612]: -M                 : a synonym for -t -D DUMP_MODULES
10月 19 12:33:53 suzuki-t httpd[2612]: -t -D DUMP_INCLUDES: show all included configuration files
10月 19 12:33:53 suzuki-t httpd[2612]: -t                 : run syntax check for config files
10月 19 12:33:53 suzuki-t httpd[2612]: -T                 : start without DocumentRoot(s) check
10月 19 12:33:53 suzuki-t httpd[2612]: -X                 : debug mode (only one worker, do not detach)
10月 19 12:33:53 suzuki-t systemd[1]: httpd.service: main process exited, code=exited, status=1/FAILURE
10月 19 12:33:53 suzuki-t systemd[1]: Failed to start The Apache HTTP Server.
10月 19 12:33:53 suzuki-t systemd[1]: Unit httpd.service entered failed state.
10月 19 12:33:53 suzuki-t systemd[1]: httpd.service failed.
↓
#環境ファイルの再作成
sudo rm /etc/sysconfig/httpd
sudo touch /etc/sysconfig/httpd
↓
[suzuki@suzuki-t ~]$ systemctl start httpd.service
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to manage system services or units.
Authenticating as: suzuki
Password:
==== AUTHENTICATION COMPLETE ===

↓
[suzuki@suzuki-t ~]$ systemctl status httpd.service
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since 火 2021-10-19 12:57:27 JST; 1min 44s ago
     Docs: man:httpd(8)
           man:apachectl(8)
  Process: 3985 ExecStart=/usr/local/httpd/httpd-2.4.48/bin/apachectl start (code=exited, status=0/SUCCESS)
 Main PID: 3988 (httpd)
   CGroup: /system.slice/httpd.service
           ├─3988 /usr/local/httpd/httpd-2.4.48/bin/httpd -k start
           ├─3989 /usr/local/httpd/httpd-2.4.48/bin/httpd -k start
           ├─3990 /usr/local/httpd/httpd-2.4.48/bin/httpd -k start
           ├─3991 /usr/local/httpd/httpd-2.4.48/bin/httpd -k start
           ├─3992 /usr/local/httpd/httpd-2.4.48/bin/httpd -k start
           └─3993 /usr/local/httpd/httpd-2.4.48/bin/httpd -k start

10月 19 12:57:27 suzuki-t systemd[1]: Starting The Apache HTTP Server...
10月 19 12:57:27 suzuki-t apachectl[3985]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using fe80::a00:27ff:fe0b:8250%enp0s3. Set the 'ServerName' dir...s this message
10月 19 12:57:27 suzuki-t systemd[1]: Started The Apache HTTP Server.
Hint: Some lines were ellipsized, use -l to show in full.



#自動起動設定
ln -s '/usr/lib/systemd/system/httpd.service' '/etc/systemd/system/multi-user.target.wants/httpd.service'

[suzuki@suzuki-t ~]$ systemctl is-enabled httpd.service
enabled


#設定解除
#rm '/etc/systemd/system/multi-user.target.wants/httpd.service'
```


## varnishの設定
### 443portはどうするのか？
443portは通常通りhttps用にlistenし、ssl認証完了後にプロキシでvarnishを経由して80portに

[suzuki@suzuki-t varnish-7.0.0]$ sudo /usr/local/varnish/sbin/varnishd -a :80 -b 192.168.56.3:8080

1回中止
案件へ

## 案件(設定情報シートのURLリンク欄を追加する)
- テーブルにカラムを追加する or 別テーブルを用意する
  - 今後複数のURLを入れる可能性
  - 現在のテーブルの条件？グループ？関連性が合っているか


### 似たようなテキストのデータでも入力が予想される文字の長さが違うことがあるので安易にtype分け等して同じカラムにしない
  - text,varcharなどなど

### DBのマイグレーションファイルの変更は他のファイルの編集とは別のプルリクエストで行うように


