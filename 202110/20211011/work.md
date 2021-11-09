```
#100クライアントで10000回
[suzuki@suzuki-t ~]$ /usr/local/siege/bin/siege --file=/var/www/html/wordpress/url_list.txt --reps=10000 --concurrent=100
** SIEGE 4.1.1
** Preparing 100 concurrent users for battle.
The server is now under siege...

HTTP/1.1 200     0.27 secs:    2984 bytes ==> GET  /wordpress/wp-includes/js/comment-reply.min.js?ver=5.8.1
HTTP/1.1 200     0.02 secs:    2897 bytes ==> GET  /wordpress/wp-content/themes/twentytwentyone/assets/css/print.css?ver=1.4
HTTP/1.1 500     0.72 secs:    2539 bytes ==> GET  /wordpress/?p=996
HTTP/1.1 200     0.06 secs:  156153 bytes ==> GET  /wordpress/wp-content/themes/twentytwentyone/style.css?ver=1.4
HTTP/1.1 500     0.09 secs:    2539 bytes ==> GET  /wordpress/?p=979
HTTP/1.1 200     0.04 secs:   80574 bytes ==> GET  /wordpress/wp-includes/css/dist/block-library/style.min.css?ver=5.8.1
HTTP/1.1 500     0.42 secs:    2539 bytes ==> GET  /wordpress/?p=361
HTTP/1.1 500     0.42 secs:    2539 bytes ==> GET  /wordpress/?p=195
HTTP/1.1 500     0.46 secs:    2539 bytes ==> GET  /wordpress/?p=804
HTTP/1.1 500     0.84 secs:    2539 bytes ==> GET  /wordpress/?p=744
HTTP/1.1 500     0.49 secs:    2539 bytes ==> GET  /wordpress/?p=591
HTTP/1.1 500     0.38 secs:    2539 bytes ==> GET  /wordpress/?p=508
HTTP/1.1 500     0.72 secs:    2539 bytes ==> GET  /wordpress/?p=755
HTTP/1.1 500     0.53 secs:    2539 bytes ==> GET  /wordpress/?p=296
HTTP/1.1 500     0.22 secs:    2539 bytes ==> GET  /wordpress/?p=362
HTTP/1.1 500     0.35 secs:    2539 bytes ==> GET  /wordpress/?p=997
HTTP/1.1 500     0.27 secs:    2539 bytes ==> GET  /wordpress/?p=980
HTTP/1.1 500     0.51 secs:    2539 bytes ==> GET  /wordpress/?p=228
HTTP/1.1 500     0.31 secs:    2539 bytes ==> GET  /wordpress/?p=196
HTTP/1.1 500     0.25 secs:    2539 bytes ==> GET  /wordpress/?p=745
HTTP/1.1 500     0.42 secs:    2539 bytes ==> GET  /wordpress/?p=422
HTTP/1.1 500     0.26 secs:    2539 bytes ==> GET  /wordpress/?p=592
HTTP/1.1 500     0.47 secs:    2539 bytes ==> GET  /wordpress/?p=805
HTTP/1.1 500     0.27 secs:    2539 bytes ==> GET  /wordpress/?p=229
HTTP/1.1 500     0.32 secs:    2539 bytes ==> GET  /wordpress/?p=981
HTTP/1.1 500     0.64 secs:    2539 bytes ==> GET  /wordpress/?p=509
HTTP/1.1 200    11.81 secs:   20388 bytes ==> GET  /wordpress/?p=86
HTTP/1.1 200     0.00 secs:    1426 bytes ==> GET  /wordpress/wp-includes/js/wp-embed.min.js?ver=5.8.1
HTTP/1.1 200     5.23 secs:   20407 bytes ==> GET  /wordpress/?p=897
HTTP/1.1 200    13.62 secs:   20407 bytes ==> GET  /wordpress/?p=261
HTTP/1.1 200     5.49 secs:   20407 bytes ==> GET  /wordpress/?p=746
HTTP/1.1 200     6.21 secs:   20407 bytes ==> GET  /wordpress/?p=239
HTTP/1.1 200     6.50 secs:   20407 bytes ==> GET  /wordpress/?p=571
HTTP/1.1 200     7.55 secs:   19989 bytes ==> GET  /wordpress/?p=1004
HTTP/1.1 200     7.92 secs:   20407 bytes ==> GET  /wordpress/?p=279
HTTP/1.1 200     8.20 secs:   20407 bytes ==> GET  /wordpress/?p=109
HTTP/1.1 200     8.34 secs:   20407 bytes ==> GET  /wordpress/?p=222
HTTP/1.1 200    17.11 secs:   20407 bytes ==> GET  /wordpress/?p=368
HTTP/1.1 200    17.67 secs:   20407 bytes ==> GET  /wordpress/?p=137
HTTP/1.1 200    14.33 secs:   20407 bytes ==> GET  /wordpress/?p=599
HTTP/1.1 200    16.99 secs:   20407 bytes ==> GET  /wordpress/?p=521
HTTP/1.1 200     7.88 secs:   20407 bytes ==> GET  /wordpress/?p=624
HTTP/1.1 200     8.41 secs:   20389 bytes ==> GET  /wordpress/?p=98


siege aborted due to excessive socket failure; you
can change the failure threshold in $HOME/.siegerc

Transactions:                 267603 hits
Availability:                  99.61 %
Elapsed time:                4942.33 secs
Data transferred:            8515.77 MB
Response time:                  1.60 secs
Transaction rate:              54.15 trans/sec
Throughput:                     1.72 MB/sec
Concurrency:                   86.37
Successful transactions:      267502
Failed transactions:            1038
Longest transaction:           77.75
Shortest transaction:           0.00

[suzuki@suzuki-t ~]$ echo $?
0

エラーログなし
アクセスログは標準出力にでているものと同じ
```

## ベンチマークテストの目的について
概ねこの２つ？
- サーバーの負荷上限を純粋に知りたい
 - サーバーの負荷を変えて確認する
- ある一定の負荷までサーバーが耐えられるようにしたい
 - サーバーの負荷は一定で設定なりを変更していく

今回の目的？

```
[suzuki@suzuki-t ~]$ /usr/local/siege/bin/siege --file=/var/www/html/wordpress/url_list.txt --reps=1000 --concurrent=25

Lifting the server siege...
Transactions:                   6060 hits
Availability:                 100.00 %
Elapsed time:                 117.09 secs
Data transferred:             188.38 MB
Response time:                  1.88 secs
Transaction rate:              51.76 trans/sec
Throughput:                     1.61 MB/sec
Concurrency:                   97.04
Successful transactions:        6057
Failed transactions:               0
Longest transaction:           15.02
Shortest transaction:           0.27

```
## ベンチマークテストの確認について
```
[suzuki@suzuki-t ~]$ top
top - 18:06:11 up  2:49,  1 user,  load average: 0.01, 0.05, 0.05
Tasks: 106 total,   1 running, 105 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.3 sy,  0.0 ni, 99.5 id,  0.0 wa,  0.0 hi,  0.2 si,  0.0 st
KiB Mem :  3880236 total,   221396 free,   921732 used,  2737108 buff/cache
KiB Swap:  4063228 total,  4063228 free,        0 used.  2599736 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
    6 root      20   0       0      0      0 S   0.3  0.0   0:04.07 ksoftirqd/0
 1531 mysql     20   0 1143980 189932   8048 S   0.3  4.9   0:28.61 mysqld
 1537 mysql     20   0 1328392 467172   5992 S   0.3 12.0   0:27.41 mysqld
 1997 suzuki    20   0  158932   2480   1124 S   0.3  0.1   0:09.49 sshd
26239 root      20   0       0      0      0 S   0.3  0.0   0:10.75 kworker/1:2
31487 root      20   0 1166204  90308  83428 S   0.3  2.3   0:05.70 cache-main
    1 root      20   0  128152   6748   4200 S   0.0  0.2   0:08.70 systemd
    2 root      20   0       0      0      0 S   0.0  0.0   0:00.02 kthreadd
    4 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/0:0H
    7 root      rt   0       0      0      0 S   0.0  0.0   0:00.62 migration/0
    8 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcu_bh
    9 root      20   0       0      0      0 S   0.0  0.0   0:10.96 rcu_sched
   10 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 lru-add-drain
   11 root      rt   0       0      0      0 S   0.0  0.0   0:00.63 watchdog/0
   12 root      rt   0       0      0      0 S   0.0  0.0   0:01.11 watchdog/1
   13 root      rt   0       0      0      0 S   0.0  0.0   0:01.15 migration/1

- load average の値が大きいほど負荷が掛かっている、小さいほうがよい
- %CPU にてメモリの使用率を確認する

[suzuki@suzuki-t local]$ sudo less /var/log/messages
の内容も確認する
```

# varnish
[参考](https://varnish-cache.org/)
## 概要
webアクセラレータの１つ
webサーバーとクライアントの間に設定する
一旦アクセスしたページのデータをWebアクセラレータがキャッシュとして保存しておき、二度目以降にユーザがアクセスをした場合には、クライアントPCからの要求がWebアクセラレータに保存されたキャッシュとWebサーバからのデータに振り分けられるようになっている。


## インストール
```
[suzuki@suzuki-t ~]$ cd /usr/local/src

[suzuki@suzuki-t src]$ sudo curl -OL https://varnish-cache.org/_downloads/varnish-7.0.0.tgz

[suzuki@suzuki-t src]$ sudo tar -xvf varnish-7.0.0.tgz

[suzuki@suzuki-t src]$ cd varnish-7.0.0

[suzuki@suzuki-t varnish-7.0.0]$ less INSTALL
                      Installation Instructions

Varnish uses the GNU autotools.  To build and install Varnish, simply
run the 'configure' script in the top-level directory, then run 'make'
and 'make install'.  On Linux, you need to run 'ldconfig' as root
afterwards in order to update the shared library cache.

If you obtained the sources directly from the Git repository, you will
need to run autogen.sh first to create the configure script.

Varnish will store run-time state in /var/run/varnish; you may
want to tune this using configure's --localstatedir parameter.

Additional configure options of interest:

  --enable-developer-warnings
                          enable strict warnings (default is NO)
  --enable-debugging-symbols
                          enable debugging symbols (default is NO)




[suzuki@suzuki-t varnish-7.0.0]$ ./configure --prefix=/usr/local/varnish

configure: error: rst2man is needed to build Varnish, please install python3-docutils.
↓

[suzuki@suzuki-t varnish-7.0.0]$ sudo yum install python36-docutils.noarch

再度configure
↓
onfigure: error: sphinx-build is needed to build Varnish, please install python3-sphinx.



[suzuki@suzuki-t varnish-7.0.0]$ sudo yum install python36-sphinx

再度configure
↓
configure: error: Package requirements (libpcre2-8) were not met:

No package 'libpcre2-8' found

Consider adjusting the PKG_CONFIG_PATH environment variable if you
installed software in a non-standard prefix.

Alternatively, you may set the environment variables PCRE2_CFLAGS
and PCRE2_LIBS to avoid the need to call pkg-config.
See the pkg-config man page for more details.



[suzuki@suzuki-t varnish-7.0.0]$ sudo yum install pcre2-devel

再度configure
↓
configure: error: neither libedit nor another readline compatible library found



[suzuki@suzuki-t varnish-7.0.0]$ sudo yum install libedit-devel

再度configure
↓
成功

#エラー処理まとめ
[suzuki@suzuki-t varnish]$ sudo yum install -y autoconf automake jemalloc-devel libedit-devel libtool libunwind-devel ncurses-devel pcre2-devel  pkgconfig python36-docutils.noarch python36-sphinx cpio

[suzuki@suzuki-t varnish-7.0.0]$ ./configure

[suzuki@suzuki-t varnish-7.0.0]$ sudo make

[suzuki@suzuki-t varnish-7.0.0]$ sudo make install

[suzuki@suzuki-t varnish-7.0.0]$ sudo ldconfig

[suzuki@suzuki-t varnish]$ sudo cp /usr/local/varnish/sbin/varnishd /etc/init.d/varnishd
[sudo] suzuki のパスワード:
[suzuki@suzuki-t varnish]$ systemctl daemon-reload
==== AUTHENTICATING FOR org.freedesktop.systemd1.reload-daemon ===
Authentication is required to reload the systemd state.
Authenticating as: suzuki
Password:
==== AUTHENTICATION COMPLETE ===
[suzuki@suzuki-t varnish]$ systemctl start varnishd
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to manage system services or units.
Authenticating as: suzuki
Password:
==== AUTHENTICATION COMPLETE ===
Job for varnishd.service failed because the control process exited with error code. See "systemctl status varnishd.service" and "journalctl -xe" for details.
↓


#8080portを解放
[suzuki@suzuki-t varnish]$ sudo iptables -I INPUT 5 -p tcp --dport 8080 -j ACCEPT

```


## 設定
https://cloudo3.com/ja/%E3%82%AF%E3%83%A9%E3%82%A6%E3%83%88%E3%82%99%E3%82%B3%E3%83%B3%E3%83%92%E3%82%9A%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%AF%E3%82%99/centos-7%E3%81%A6%E3%82%99apache%E3%81%AEvarnish-cache-5-0%E3%83%95%E3%82%9A%E3%83%AD%E3%82%AD%E3%82%B7%E3%82%92%E8%A8%AD%E5%AE%9A%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95/2157
```
#apacheの停止
[suzuki@suzuki-t varnish-7.0.0]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl stop

#apacheの設定変更
[suzuki@suzuki-t varnish-7.0.0]$ sudo vi /usr/local/httpd/httpd-2.4.48/conf/httpd.conf

Listen 80 -> Listen 8080

#8080portにてapache起動
[suzuki@suzuki-t varnish-7.0.0]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl start

#varnish起動
[suzuki@suzuki-t varnish-7.0.0]$ sudo /usr/local/sbin/varnishd -a :80 -b suzuki-t.com:8080

#確認
[suzuki@suzuki-t local]$ curl -I http://suzuki-t.com
HTTP/1.1 200 OK
Date: Mon, 11 Oct 2021 08:54:39 GMT
Server: Apache/2.4.48 (Unix) OpenSSL/1.0.2k-fips PHP/7.4.23
Last-Modified: Mon, 11 Jun 2007 18:53:14 GMT
ETag: "2d-432a5e4a73a80"
Content-Length: 45
Content-Type: text/html
X-Varnish: 2
Age: 0
Via: 1.1 varnish (Varnish/7.0)　←
Accept-Ranges: bytes
Connection: keep-alive

```