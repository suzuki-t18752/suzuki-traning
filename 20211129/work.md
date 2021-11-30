```
2021/11/29 11:24:12 [error] 986#986: *3 "/var/www/html/index.html" is forbidden (13: Permission denied), client: 192.168.56.1, server: suzuki-t.com, request: "GET / HTTP/1.1", host: "suzuki-t.com"
2021/11/29 11:24:13 [error] 986#986: *3 "/var/www/html/index.html" is forbidden (13: Permission denied), client: 192.168.56.1, server: suzuki-t.com, request: "GET / HTTP/1.1", host: "suzuki-t.com"
2021/11/29 11:24:17 [error] 986#986: *3 open() "/var/www/html/index.html" failed (13: Permission denied), client: 192.168.56.1, server: suzuki-t.com, request: "GET /index.html HTTP/1.1", host: "suzuki-t.com"
```

```
root      1682  0.0  0.0  46520   972 ?        Ss   11:42   0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
nginx     1683  0.0  0.0  46984  2108 ?        S    11:42   0:00 nginx: worker process
nginx     1684  0.0  0.0  46984  2108 ?        S    11:42   0:00 nginx: worker process


[suzuki@suzuki-t ~]$ ls -l /var/www
合計 0
drwxr-xr-x. 2 nginx nginx 24 11月 24 18:59 html
[suzuki@suzuki-t ~]$ ls -l /var/www/html/
合計 4
-rw-r--r--. 1 nginx nginx 73 11月 24 18:59 index.html
[suzuki@suzuki-t ~]$ groups nginx
nginx : nginx

#上記のようにnginx権限に変更しても変わらず
#エラーはかわらず
```

- SElinuxが関係しているらしい
```
[suzuki@suzuki-t ~]$ sudo setenforce 0
[suzuki@suzuki-t ~]$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   permissive
Mode from config file:          permissive
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Max kernel policy version:      31

# 上記コマンドにてCurrent modeをpermissiveに変更することでエラーが解消した


[suzuki@suzuki-t ~]$ ls -Z /var/www/html
-rw-r--r--. nginx nginx unconfined_u:object_r:var_t:s0   index.html
[suzuki@suzuki-t ~]$ restorecon -R /var/www/html
restorecon set context /var/www/html->unconfined_u:object_r:httpd_sys_content_t:                                                                                                                                   s0 failed:'Operation not permitted'
[suzuki@suzuki-t ~]$ sudo restorecon -R /var/www/html
[sudo] suzuki のパスワード:
[suzuki@suzuki-t ~]$ ls -Z /var/www/html
-rw-r--r--. nginx nginx unconfined_u:object_r:httpd_sys_content_t:s0 index.html
[suzuki@suzuki-t ~]$ sudo setenforce 1
[suzuki@suzuki-t ~]$ sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          permissive
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Max kernel policy version:      31

# 上記コマンドにて
```
[SElinuxの設定](https://blog.fenrir-inc.com/jp/2016/09/selinux.html)
## [SElinux](SELinuxを利用すると細かいアクセス制御が可能になる。例えば、サービス毎に最小限の権限を与え管理することなどが可能になる)
- SELinuxを利用すると細かいアクセス制御が可能になる。例えば、サービス毎に最小限の権限を与え管理することなどが可能になる
- 設定の確認 sestatusコマンド
  - enforcing SELinux有効でありアクセス制御が有効となる
  - permissive アクセス制御は無効だが警告メッセージを表示する
  - disabled SELinux無効
