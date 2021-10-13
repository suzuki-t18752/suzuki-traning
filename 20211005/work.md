## .shの実行時にtee -a ***.logを設定する
#source work.sh | tee -a ./work_sh.log
#上記にて実行する(標準入出力をロギングする)

## パスワードファイルの参照方法を相対パスに変更する
export $(cat /root/.pass)
↓
export $(cat ./.pass)

## 自動起動設定も実施する
追加
systemctl enable mysql56
systemctl enable mysql57

## mysqlの文字コードをutf8からutf8mb4に変更する
現代では絵文字等も扱う為
```
patch -R /etc/my.cnf << EOF
2,6c2,3
< datadir=/usr/local/mysql5.7/data
< socket=/usr/local/mysql5.7/data/mysql.sock
< port=3306
< character-set-server=utf8mb4
< collation-server=utf8_general_ci
---
> datadir=/var/lib/mysql
> socket=/var/lib/mysql/mysql.sock
EOF
```

## 長いコードの改行
例
```
yum -y install patch cmake ncurses-devel zlib-devel \
libaio-devel openssl-devel gcc-c++ bison \
gcc make pcre-devel expat-devel \
openssl-devel libcurl-devel libpng-devel libicu-devel \
libxml2-devel sqlite-devel perl oniguruma-devel \
libsodium-devel perl-Data-Dumper iptables-services
```

## ファイル内の段落分けをする
```
#apache###########################################################################


##################################################################################
```











## phpにzend opcacheモジュールを追加
### opcacheとは
OPcache はコンパイル済みのバイトコード(仮想マシン用の命令コード)を共有メモリに保存し、PHP がリクエストのたびにスクリプトを読み込み、パース(一定の書式や文法に従って記述されたデータを解析し、プログラムで扱えるようなデータ構造の集合体に変換すること)する手間を省くことでパフォーマンスを向上させる

### インストール方法
[参考](https://www.php.net/manual/ja/opcache.installation.php)
上記ページより推奨設定
- opcache.memory_consumption=128　OPcache によって使用される共有メモリ・ストレージのサイズ

- opcache.interned_strings_buffer=8
インターン化された文字列を格納するために使用されるメモリ量
[intern化文字列とは](https://hnw.hatenablog.com/entry/20151205)
同じ文字列を扱う場合に何度もコピーして別々のメモリに保存されてそれぞれ取得するものを1度コピーしたメモリから取得するようにすること

- opcache.max_accelerated_files=4000
OPcache ハッシュテーブルのキーの最大数
ハッシュテーブルとは、データ構造の一つで、標識（キー：key）と対応する値（value）のペアを単位としてデータを格納し、キーを指定すると対応する値を高速に取得できる構造

- opcache.revalidate_freq=60
更新のためにスクリプトのタイムスタンプをチェックする頻度


- opcache.enable_cli=1　
PHP の CLI 版に対してopchaceを有効にする


#設定変更
patch /usr/local/lib/php.ini << EOF
465c465
< error_reporting = E_ALL
---
> error_reporting = E_ALL ^ E_NOTICE ^ E_DEPRECATED
482c482
< display_errors = On
---
> display_errors = Off
586c586
< ;error_log = php_errors.log
---
> error_log = /usr/local/php/log/php_errors.log
694c694
< post_max_size = 8M
---
> post_max_size = 64M
846c846
< upload_max_filesize = 2M
---
> upload_max_filesize = 32M
1767a1768
> zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20190902/opcache.so
1769c1770
< ;opcache.enable=1
---
> opcache.enable=1
1772c1773
< ;opcache.enable_cli=0
---
> opcache.enable_cli=1
1775c1776
< ;opcache.memory_consumption=128
---
> opcache.memory_consumption=128
1778c1779
< ;opcache.interned_strings_buffer=8
---
> opcache.interned_strings_buffer=8
1782c1783
< ;opcache.max_accelerated_files=10000
---
> opcache.max_accelerated_files=4000
1800c1801
< ;opcache.revalidate_freq=2
---
> opcache.revalidate_freq=60
EOF


#確認
php -v
PHP 7.4.23 (cli) (built: Oct  4 2021 15:39:26) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies
    with Zend OPcache v7.4.23, Copyright (c), by Zend Technologies

php --info | grep opcache
opcache.blacklist_filename => no value => no value
opcache.consistency_checks => 0 => 0
opcache.dups_fix => Off => Off
opcache.enable => On => On
opcache.enable_cli => On => On
opcache.enable_file_override => Off => Off
opcache.error_log => no value => no value
opcache.file_cache => no value => no value
opcache.file_cache_consistency_checks => On => On
opcache.file_cache_only => Off => Off
opcache.file_update_protection => 2 => 2
opcache.force_restart_timeout => 180 => 180
opcache.huge_code_pages => Off => Off
opcache.interned_strings_buffer => 8 => 8
opcache.lockfile_path => /tmp => /tmp
opcache.log_verbosity_level => 1 => 1
opcache.max_accelerated_files => 4000 => 4000
opcache.max_file_size => 0 => 0
opcache.max_wasted_percentage => 5 => 5
opcache.memory_consumption => 128 => 128
opcache.opt_debug_level => 0 => 0
opcache.optimization_level => 0x7FFEBFFF => 0x7FFEBFFF
opcache.preferred_memory_model => no value => no value
opcache.preload => no value => no value
opcache.preload_user => no value => no value
opcache.protect_memory => Off => Off
opcache.restrict_api => no value => no value
opcache.revalidate_freq => 60 => 60
opcache.revalidate_path => Off => Off
opcache.save_comments => On => On
opcache.use_cwd => On => On
opcache.validate_permission => Off => Off
opcache.validate_root => Off => Off
opcache.validate_timestamps => On => On



## pharについて
phpのアーカイブファイル(複数のファイルを1つにまとめたもの)のこと

## composerについて
phpのソフトウェアや必要なライブラリの依存関係を管理するシステム

## composerを使えるようにする
[参考](https://getcomposer.org/doc/00-intro.md)
```
#インストール用ファイルのダウンロード
[suzuki@suzuki-t src]$ sudo curl -O https://getcomposer.org/installer

#phpファイルとして実行する為、ファイル名を変更
[suzuki@suzuki-t src]$ sudo mv installer composer-setup.php

#実行
[suzuki@suzuki-t src]$ sudo php composer-setup.php
Some settings on your machine make Composer unable to work properly.
Make sure that you fix the issues listed below and run this script again:

The openssl extension is missing, which means that secure HTTPS transfers are impossible.
If possible you should enable it or recompile php with --with-openssl
↓
phpのconfigureの際のオプションを変更
--with-openssl-dir=/usr/bin/　→　--with-openssl

[suzuki@suzuki-t src]$ sudo mv composer.phar /usr/local/bin/composer

[suzuki@suzuki-t src]$ composer -v
   ______
  / ____/___  ____ ___  ____  ____  ________  _____
 / /   / __ \/ __ `__ \/ __ \/ __ \/ ___/ _ \/ ___/
/ /___/ /_/ / / / / / / /_/ / /_/ (__  )  __/ /
\____/\____/_/ /_/ /_/ .___/\____/____/\___/_/
                    /_/
Composer version 2.1.8 2021-09-15 13:55:14


```
[使い方などなど](https://qiita.com/niisan-tokyo/items/8cccec88d45f38171c94)


## xdebugをインストールして有効化する
### xdebug
phpの拡張機能
- エラーが発生するまでの経過を詳細に表示する。関数に渡されたパラメーターも表示され、エラーの原因を探しやすくする
- var_dumpを整形して出力する 色分けした情報と構造化ビューを生成
- PHPアプリケーションのパフォーマンスを分析し、ボトルネックを見つけることができる
- PHPUnitで単体テストを実行するときにどの部分のコードがテストされたか分かる

### インストール、設定
[参考](https://xdebug.org/docs/install)
```
[suzuki@suzuki-t ~]$ sudo yum install php-xdebug
xdebugのパッケージインストール時に依存関係のパッケージとしてphpがインストールされてしまうのでNG

sudo yum remove libxslt libzip php-cli php-common php-pear php-process php-xml



#ソースコードからインストールする
[suzuki@suzuki-t src]$ sudo curl -OL https://xdebug.org/files/xdebug-3.1.0.tgz

[suzuki@suzuki-t src]$ sudo tar xvf xdebug-3.1.0.tgz

[suzuki@suzuki-t src]$ cd xdebug-3.1.0

[suzuki@suzuki-t xdebug-3.1.0]$ sudo /usr/local/bin/phpize
Configuring for:
PHP Api Version:         20190902
Zend Module Api No:      20190902
Zend Extension Api No:   320190902
Cannot find autoconf. Please check your autoconf installation and the
$PHP_AUTOCONF environment variable. Then, rerun this script.
↓
[suzuki@suzuki-t xdebug-3.1.0]$ sudo yum install autoconf

[suzuki@suzuki-t xdebug-3.1.0]$ sudo ./configure --enable-xdebug
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for a sed that does not truncate output... /bin/sed
checking for pkg-config... /bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for cc... cc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether cc accepts -g... yes
checking for cc option to accept ISO C89... none needed
checking how to run the C preprocessor... cc -E
checking for icc... no
checking for suncc... no
checking for system library directory... lib
checking if compiler supports -R... no
checking if compiler supports -Wl,-rpath,... yes
checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
checking target system type... x86_64-pc-linux-gnu
configure: error: Cannot find php-config. Please use --with-php-config=PATH
↓
[suzuki@suzuki-t xdebug-3.1.0]$ sudo ./configure --enable-xdebug --with-php-config=/usr/local/bin/php-config

[suzuki@suzuki-t xdebug-3.1.0]$ sudo make

[suzuki@suzuki-t xdebug-3.1.0]$ sudo make install
Makefile:228: warning: overriding recipe for target `test'
Makefile:132: warning: ignoring old recipe for target `test'
Installing shared extensions:     /usr/local/lib/php/extensions/no-debug-non-zts-20190902/

  +----------------------------------------------------------------------+
  |                                                                      |
  |   INSTALLATION INSTRUCTIONS                                          |
  |   =========================                                          |
  |                                                                      |
  |   See https://xdebug.org/install.php#configure-php for instructions  |
  |   on how to enable Xdebug for PHP.                                   |
  |                                                                      |
  |   Documentation is available online as well:                         |
  |   - A list of all settings:  https://xdebug.org/docs-settings.php    |
  |   - A list of all functions: https://xdebug.org/docs-functions.php   |
  |   - Profiling instructions:  https://xdebug.org/docs-profiling2.php  |
  |   - Remote debugging:        https://xdebug.org/docs-debugger.php    |
  |                                                                      |
  |                                                                      |
  |   NOTE: Please disregard the message                                 |
  |       You should add "extension=xdebug.so" to php.ini                |
  |   that is emitted by the PECL installer. This does not work for      |
  |   Xdebug.                                                            |
  |                                                                      |
  +----------------------------------------------------------------------+

[suzuki@suzuki-t xdebug-3.1.0]$ sudo vi /usr/local/lib/php.ini
下記を追記
extension=xdebug.so

[suzuki@suzuki-t xdebug-3.1.0]$ php -v
PHP Warning:  Xdebug MUST be loaded as a Zend extension in Unknown on line 0
↓
[suzuki@suzuki-t xdebug-3.1.0]$ sudo vi /usr/local/lib/php.ini
下記を追記
zend_extension=xdebug.so

[suzuki@suzuki-t xdebug-3.1.0]$ php -v
PHP 7.4.23 (cli) (built: Oct  5 2021 15:15:40) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies
    with Xdebug v3.1.0, Copyright (c) 2002-2021, by Derick Rethans
    with Zend OPcache v7.4.23, Copyright (c), by Zend Technologies
```
