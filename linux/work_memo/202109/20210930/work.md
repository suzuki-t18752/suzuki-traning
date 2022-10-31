# gitを使う為にwsl,ubuntuをインストール、設定を行う

## wslのインストール実施


## ubuntuのインストール実施



https://docs.github.com/ja/github/authenticating-to-github/connecting-to-github-with-ssh/testing-your-ssh-connection

apt update

apt upgrade

ssh-keygen -t rsa -b 4096 -C "tkft.psy@gmail.com"

ssh -T git@github.com
The authenticity of host 'github.com (52.69.186.44)' can't be established.
RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com,52.69.186.44' (RSA) to the list of known hosts.
Hi suzuki-t18752! You've successfully authenticated, but GitHub does not provide shell access.

git config --global user.email "suzukit@suzuki.jp" 
git config --global user.name "suzuki" 


### mntディレクトリにcドライブがある








コマンドライン化したもののテストを実施する

改めて環境を作成、
rootディレクトリにシェルスクリプトのファイル、パスワード用のファイル、投稿用の画像ファイルを用意、
sourceコマンドにてシェルスクリプトファイルを実行

rootディレクトリに実行した結果を残す(work_sh.log)




[root@localhost ~]# cat work_sh.log
0 yum_update\n
0 hostname_update\n
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.56.3   suzuki-t.com
192.168.56.3   suzuki-t.net
0 patch_install\n
0 pake_install\n
0 iptables_install\n
0 firewalled_off\n
0 firewalled_off2\n
0 iptables_on\n
0 iptables_on2\n
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
0 iptables_save\n
0 pake_install\n
0 pake_install\n
0 apache_on\n
0 php_install\n
0 cp php,ini\n
0 filesize php,ini\n
0 filesize2 php,ini\n
0 error_log php,ini\n
0 mysql group\n
0 mysql user\n
0 mysql5.7_install\n
0 mysql5.7 data\n
[mysqld]
datadir=/usr/local/mysql5.7/data
socket=/usr/local/mysql5.7/data/mysql.sock
port=3306
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
# Settings user and group are ignored when systemd is used.
# If you need to run mysqld under a different user or group,
# customize your systemd unit file for mariadb according to the
# instructions in http://fedoraproject.org/wiki/Systemd

[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid

#
# include all files from the config directory
#
!includedir /etc/my.cnf.d

0 mysql5.7 on\n
suzuki0901
0 mysql5.7 root update\n
0 mysql5.7 restart\n
0 mysql5.7 root pass\n
0 mysql5.7 wp user\n
0 mysql5.7 wp db\n
0 mysql5.7 wp db grant\n
0 httpd.conf\n
0 vhosts\n
0 basic\n
0 wordpress1 serberkey\n
0 apache restart\n
0 wordpress1 install\n
0 ssl.conf\n
0 mysql5.6 install\n
0 pake_install\n
0 mysql5.6 data\n
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/5.6/en/server-configuration-defaults.html

[mysqld]

# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M

# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin

# These are commonly set, remove the # and set as required.
basedir = /usr/local/mysql5.6
datadir = /usr/local/mysql5.6/data
port = 3307
# server_id = .....
socket = /usr/local/mysql5.6/data/mysql.sock

# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
0 mysql5.6 on\n
0 mysql5.6 wordpress2 user\n
0 mysql5.6 wordpress2 wp db\n
0 mysql5.6 wordpress2 wp db grant\n
0 mysql5.6 wordpress2 install\n
0 digest\n
0 wordpress2 sslkey\n
OS:     Linux 3.10.0-1160.el7.x86_64 #1 SMP Mon Oct 19 16:18:59 UTC 2020 x86_64
Shell:  /bin/bash
PHP binary:     /usr/local/bin/php
PHP version:    7.4.23
php.ini used:   /usr/local/lib/php.ini
MySQL binary:
MySQL version:
SQL modes:
WP-CLI root dir:        phar://wp-cli.phar/vendor/wp-cli/wp-cli
WP-CLI vendor dir:      phar://wp-cli.phar/vendor
WP_CLI phar path:       /usr/local/src
WP-CLI packages dir:
WP-CLI global config:
WP-CLI project config:
WP-CLI version: 2.5.0
0 wordpress1 config\n
0 wordpress1 site\n
0 wordpress1 post\n
0 wordpress1 image\n
0 wordpress1 post open\n
0 wordpress2 config\n
0 wordpress2 site\n



全て実行完了後
ページを開くと
<?php
/**
 * Front to the WordPress application. This file doesn't do anything, but loads
 * wp-blog-header.php which does and tells WordPress to load the theme.
 *
 * @package WordPress
 */

/**
 * Tells WordPress to load the WordPress theme and output it.
 *
 * @var bool
 */
define( 'WP_USE_THEMES', true );

/** Loads the WordPress Environment and Template */
require __DIR__ . '/wp-blog-header.php';


# gitを使う為にwsl,ubuntuをインストール、設定を行う

## wslのインストール実施


## ubuntuのインストール実施



https://docs.github.com/ja/github/authenticating-to-github/connecting-to-github-with-ssh/testing-your-ssh-connection

apt update

apt upgrade

ssh-keygen -t rsa -b 4096 -C "tkft.psy@gmail.com"

ssh -T git@github.com
The authenticity of host 'github.com (52.69.186.44)' can't be established.
RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com,52.69.186.44' (RSA) to the list of known hosts.
Hi suzuki-t18752! You've successfully authenticated, but GitHub does not provide shell access.

git config --global user.email "suzukit@suzuki.jp" 
git config --global user.name "suzuki" 


### mntディレクトリにcドライブがある
=======
### apacheアクセスログ
192.168.56.3 - - [30/Sep/2021:15:48:38 +0900] "POST /wp-cron.php?doing_wp_cron=1632984518.2457571029663085937500 HTTP/1.1" 404 196
192.168.56.1 - - [30/Sep/2021:15:48:56 +0900] "GET /wordpress/ HTTP/1.1" 200 405
192.168.56.1 - suzuki [30/Sep/2021:15:49:04 +0900] "GET /wordpress/wp-admin/ HTTP/1.1" 200 7168
192.168.56.1 - - [30/Sep/2021:15:49:56 +0900] "-" 408 -



## apacheエラーログ
[Thu Sep 30 15:48:15.118722 2021] [mpm_prefork:notice] [pid 16994] AH00171: Graceful restart requested, doing restart
[Thu Sep 30 15:48:15.133921 2021] [so:warn] [pid 16994] AH01574: module php7_module is already loaded, skipping
AH00112: Warning: DocumentRoot [/var/www/html] does not exist
AH00112: Warning: DocumentRoot [/var/www/html2] does not exist
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using fe80::a00:27ff:fe0b:8250%enp0s3. Set the 'ServerName' directive globally to suppress this message
[Thu Sep 30 15:48:15.140655 2021] [ssl:info] [pid 16994] AH01883: Init: Initialized OpenSSL library
[Thu Sep 30 15:48:15.140721 2021] [socache_shmcb:debug] [pid 16994] mod_socache_shmcb.c(417): AH00821: shmcb_init allocated 512000 bytes of shared memory
[Thu Sep 30 15:48:15.140725 2021] [socache_shmcb:debug] [pid 16994] mod_socache_shmcb.c(433): AH00822: for 511912 bytes (512000 including header), recommending 32 subcaches, 88 indexes each
[Thu Sep 30 15:48:15.140727 2021] [socache_shmcb:debug] [pid 16994] mod_socache_shmcb.c(466): AH00824: shmcb_init_memory choices follow
[Thu Sep 30 15:48:15.140728 2021] [socache_shmcb:debug] [pid 16994] mod_socache_shmcb.c(468): AH00825: subcache_num = 32
[Thu Sep 30 15:48:15.140729 2021] [socache_shmcb:debug] [pid 16994] mod_socache_shmcb.c(470): AH00826: subcache_size = 15992
[Thu Sep 30 15:48:15.140729 2021] [socache_shmcb:debug] [pid 16994] mod_socache_shmcb.c(472): AH00827: subcache_data_offset = 2128
[Thu Sep 30 15:48:15.140730 2021] [socache_shmcb:debug] [pid 16994] mod_socache_shmcb.c(474): AH00828: subcache_data_size = 13864
[Thu Sep 30 15:48:15.140731 2021] [socache_shmcb:debug] [pid 16994] mod_socache_shmcb.c(476): AH00829: index_num = 88
[Thu Sep 30 15:48:15.140769 2021] [socache_shmcb:info] [pid 16994] AH00830: Shared memory socache initialised
[Thu Sep 30 15:48:15.140770 2021] [ssl:info] [pid 16994] AH01887: Init: Initializing (virtual) servers for SSL
[Thu Sep 30 15:48:15.140772 2021] [ssl:info] [pid 16994] AH01914: Configuring server www.example.com:443 for SSL protocol
[Thu Sep 30 15:48:15.140868 2021] [ssl:debug] [pid 16994] ssl_engine_init.c(506): AH01893: Configuring TLS extension handling
[Thu Sep 30 15:48:15.141179 2021] [ssl:debug] [pid 16994] ssl_util_ssl.c(451): AH02412: [www.example.com:443] Cert does not match for name 'www.example.com' [subject: CN=suzuki-t.com,O=suzuki,L=shibuya-ku,ST=Tokyo,C=JP / issuer: CN=suzuki-t.com,O=suzuki,L=shibuya-ku,ST=Tokyo,C=JP / serial: F9F769AE260DFE48 / notbefore: Sep 30 06:48:15 2021 GMT / notafter: Sep 28 06:48:15 2031 GMT]
[Thu Sep 30 15:48:15.141194 2021] [ssl:warn] [pid 16994] AH01909: www.example.com:443:0 server certificate does NOT include an ID which matches the server name
[Thu Sep 30 15:48:15.141196 2021] [ssl:info] [pid 16994] AH02568: Certificate and private key www.example.com:443:0 configured from /usr/local/httpd/httpd-2.4.48/conf/server.crt and /usr/local/httpd/httpd-2.4.48/conf/server.key
[Thu Sep 30 15:48:15.141258 2021] [ssl:info] [pid 16994] AH01876: mod_ssl/2.4.48 compiled against Server: Apache/2.4.48, Library: OpenSSL/1.0.2k
[Thu Sep 30 15:48:15.141374 2021] [mpm_prefork:notice] [pid 16994] AH00163: Apache/2.4.48 (Unix) OpenSSL/1.0.2k-fips configured -- resuming normal operations
[Thu Sep 30 15:48:15.141377 2021] [mpm_prefork:info] [pid 16994] AH00164: Server built: Sep 30 2021 15:13:41
[Thu Sep 30 15:48:15.141379 2021] [core:notice] [pid 16994] AH00094: Command line: '/usr/local/httpd/httpd-2.4.48/bin/httpd'
[Thu Sep 30 15:48:15.141380 2021] [core:debug] [pid 16994] log.c(1573): AH02639: Using SO_REUSEPORT: yes (1)
[Thu Sep 30 15:48:15.141383 2021] [mpm_prefork:debug] [pid 16994] prefork.c(919): AH00165: Accept mutex: pthread (default: pthread)
[Thu Sep 30 15:48:37.922956 2021] [ssl:info] [pid 32025] [client 192.168.56.3:44954] AH01964: Connection to child 1 established (server www.example.com:443)
[Thu Sep 30 15:48:37.923188 2021] [ssl:debug] [pid 32025] ssl_engine_kernel.c(2404): [client 192.168.56.3:44954] AH02044: No matching SSL virtual host for servername suzuki-t.com found (using default/first virtual host)
[Thu Sep 30 15:48:37.925490 2021] [ssl:info] [pid 32025] [client 192.168.56.3:44954] AH02008: SSL library error 1 in handshake (server www.example.com:443)
[Thu Sep 30 15:48:37.925511 2021] [ssl:info] [pid 32025] SSL Library Error: error:14094418:SSL routines:ssl3_read_bytes:tlsv1 alert unknown ca (SSL alert number 48)
[Thu Sep 30 15:48:37.925517 2021] [ssl:info] [pid 32025] [client 192.168.56.3:44954] AH01998: Connection closed to child 1 with abortive shutdown (server www.example.com:443)
[Thu Sep 30 15:48:37.954357 2021] [ssl:info] [pid 32028] [client 192.168.56.3:44956] AH01964: Connection to child 4 established (server www.example.com:443)
[Thu Sep 30 15:48:37.954578 2021] [ssl:debug] [pid 32028] ssl_engine_kernel.c(2404): [client 192.168.56.3:44956] AH02044: No matching SSL virtual host for servername suzuki-t.com found (using default/first virtual host)
[Thu Sep 30 15:48:37.956805 2021] [ssl:info] [pid 32028] [client 192.168.56.3:44956] AH02008: SSL library error 1 in handshake (server www.example.com:443)
[Thu Sep 30 15:48:37.956826 2021] [ssl:info] [pid 32028] SSL Library Error: error:14094418:SSL routines:ssl3_read_bytes:tlsv1 alert unknown ca (SSL alert number 48)
[Thu Sep 30 15:48:37.956831 2021] [ssl:info] [pid 32028] [client 192.168.56.3:44956] AH01998: Connection closed to child 4 with abortive shutdown (server www.example.com:443)
[Thu Sep 30 15:48:38.313070 2021] [ssl:info] [pid 32026] [client 192.168.56.3:44960] AH01964: Connection to child 2 established (server www.example.com:443)
[Thu Sep 30 15:48:38.313298 2021] [ssl:debug] [pid 32026] ssl_engine_kernel.c(2404): [client 192.168.56.3:44960] AH02044: No matching SSL virtual host for servername suzuki-t.com found (using default/first virtual host)
[Thu Sep 30 15:48:38.317333 2021] [socache_shmcb:debug] [pid 32026] mod_socache_shmcb.c(510): AH00831: socache_shmcb_store (0xe2 -> subcache 2)
[Thu Sep 30 15:48:38.317345 2021] [socache_shmcb:debug] [pid 32026] mod_socache_shmcb.c(864): AH00847: insert happened at idx=0, data=(0:32)
[Thu Sep 30 15:48:38.317346 2021] [socache_shmcb:debug] [pid 32026] mod_socache_shmcb.c(869): AH00848: finished insert, subcache: idx_pos/idx_used=0/1, data_pos/data_used=0/196
[Thu Sep 30 15:48:38.317349 2021] [socache_shmcb:debug] [pid 32026] mod_socache_shmcb.c(531): AH00834: leaving socache_shmcb_store successfully
[Thu Sep 30 15:48:38.317357 2021] [ssl:debug] [pid 32026] ssl_engine_kernel.c(2257): [client 192.168.56.3:44960] AH02041: Protocol: TLSv1.2, Cipher: ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits)
[Thu Sep 30 15:48:38.317541 2021] [ssl:debug] [pid 32026] ssl_engine_kernel.c(422): [client 192.168.56.3:44960] AH02034: Initial (No.1) HTTPS request received for child 2 (server www.example.com:443), referer: https://suzuki-t.com/wp-cron.php?doing_wp_cron=1632984518.2457571029663085937500
[Thu Sep 30 15:48:38.317619 2021] [authz_core:debug] [pid 32026] mod_authz_core.c(818): [client 192.168.56.3:44960] AH01626: authorization result of Require all granted: granted, referer: https://suzuki-t.com/wp-cron.php?doing_wp_cron=1632984518.2457571029663085937500
[Thu Sep 30 15:48:38.317623 2021] [authz_core:debug] [pid 32026] mod_authz_core.c(818): [client 192.168.56.3:44960] AH01626: authorization result of <RequireAny>: granted, referer: https://suzuki-t.com/wp-cron.php?doing_wp_cron=1632984518.2457571029663085937500

sslがうまくいかないのはipアドレスの変更忘れ

インストール時のurl設定にミスがあったため
wp core install --title=suzuki_blog --admin_user=suzuki --admin_password=$root --admin_email=suzukit@suzuki.jp --allow-root --url='https://suzuki-t.com'
上記から下記に変更
wp core install --title=suzuki_blog --admin_user=suzuki --admin_password=$root --admin_email=suzukit@suzuki.jp --allow-root --url='https://suzuki-t.com/wordpress'

urlにミスがあった為、urlから開くページはそのままurlからファイルを参照できていたが、そのファイルから参照しているファイルに関してはインストール時に設定したurlをベースにファイルを検索していた為、見つけることが出来ずphpのソースがそのまま表示されていた。

エラーログを見たときに
[Thu Sep 30 15:48:38.317623 2021] [authz_core:debug] [pid 32026] mod_authz_core.c(818): [client 192.168.56.3:44960] AH01626: authorization result of <RequireAny>: granted, referer: https://suzuki-t.com/wp-cron.php?doing_wp_cron=1632984518.2457571029663085937500
上記の部分に気が付くべきだった。
