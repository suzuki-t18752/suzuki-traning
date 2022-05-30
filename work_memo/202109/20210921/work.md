## SSL
SSL（Secure Sockets Layer）とは、インターネット上におけるウェブブラウザとウェブサーバ間でのデータの通信を暗号化し、送受信させる仕組みのこと
ウェブサイトでSSL(https)を利用する場合、通信の暗号化に必要な鍵とウェブサイトの運営者の情報が含まれた「SSLサーバ証明書」を、サーバにインストールする必要があります。

### SSLサーバ証明書
SSLサーバ証明書は、ウェブサイトの「運営者の実在性を確認」し、ブラウザとウェブサーバ間で「通信データの暗号化」を行うための電子証明書で、GMOグローバルサインなどの認証局から発行されます。
SSLサーバ証明書には、ウェブサイトの所有者の情報や、暗号化通信に必要な鍵、発行者の署名データが含まれています。
SSLサーバ証明書に含まれる2つの鍵(共通鍵暗号方式・公開鍵暗号方式)によって、ブラウザ⇔サーバ間で送受信される個人情報や決済情報などの通信データを暗号化することができます

- SSLサーバ証明書の種類
1. ドメイン認証  

ウェブサイトのドメインの使用権を所有していることを認証します。
組織の実在性は確認しないため、登記簿謄本などの提出は不要、個人事業主の方でも証明書の申請が可能です。

2. 企業実在認証

ウェブサイトのドメインの使用権の所有の他、その運営組織が法的に実在すること認証します。
第三者データベースに照会の上確認し、さらに申し込みの意思を確認の上証明書が発行されます。

3. EV認証

世界標準のガイドラインに沿って、ドメインの使用権の他、その運営組織の法的・物理的実在性を第三者データベースに照会の上確認し、さらに申し込みの意思と権限を確認の上証明書が発行されます。

### 設定(今回は自己証明書にて行う)
[参考](https://weblabo.oscasierra.net/openssl-gencert-1/)
```
#
[suzuki@os1 ssl]$ cd /usr/local/httpd/httpd-2.4.48/conf/

#秘密鍵の作成
[suzuki@os1 ssl]$ openssl genrsa 2024 > server.key
sudo sh -c " openssl genrsa 2024 > server.key"

#証明書署名要求(CSR / Certificate Signing Request)の作成
[suzuki@os1 ssl]$ openssl req -new -key server.key > server.csr
sudo sh -c "openssl req -new -key server.key > server.csr"


```
###  証明書署名要求
認証局にサーバの公開鍵に電子署名してもらうよう要求するメッセージです。 (本稿では自己証明書を作成する為、認証局も自分自身ということになります) OpenSSL で証明書署名要求を作成するには openssl req コマンドを実行します

### サーバ証明書の作成
普通であれば上で作成した証明書署名要求 (server.csr) を VeriSign などの機関に送付して認証局の秘密鍵で署名してもらいます。

今回は自分で署名することでサーバ証明書を作成しますので上で作成した自分の秘密鍵 (server.key) で署名します。 サーバ証明書に署名するには openssl x509 コマンドを実行します。 今回は証明書の有効期限が10年(3650日)ある証明書を作成します。

```
#サーバ証明書の作成
[suzuki@os1 ssl]$ openssl x509 -req -days 3650 -signkey server.key < server.csr > server.crt
sudo sh -c "openssl x509 -req -days 3650 -signkey server.key < server.csr > server.crt"

#設定ファイルのコピー
[suzuki@os1 ssl]$ sudo cp /usr/local/httpd/httpd-2.4.48/conf/httpd.conf /usr/local/httpd/httpd-2.4.48/conf/httpd.conf.bak_20210917

#設定ファイルの変更
[suzuki@os1 ssl]$ sudo sed -i -e 's%#Include conf/extra/httpd-ssl.conf%Include conf/extra/httpd-ssl.conf%g' /usr/local/httpd/httpd-2.4.48/conf/httpd.conf

[suzuki@os1 ssl]$ sudo sed -i -e 's%#LoadModule socache_shmcb_module modules/mod_socache_shmcb.so%LoadModule socache_shmcb_module modules/mod_socache_shmcb.so%g' /usr/local/httpd/httpd-2.4.48/conf/httpd.conf

[suzuki@os1 ssl]$ sudo sed -i -e 's%#LoadModule ssl_module modules/mod_ssl.so%LoadModule ssl_module modules/mod_ssl.so%g' /usr/local/httpd/httpd-2.4.48/conf/httpd.conf

[suzuki@os1 ssl]$ diff -i /usr/local/httpd/httpd-2.4.48/conf/httpd.conf /usr/local/httpd/httpd-2.4.48/conf/httpd.conf.bak_20210917



[suzuki@os1 ~]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl -t

```

### エラーSSLCipherSuite HIGH:MEDIUM:!MD5:!RC4:!3DES
apacheのconfigure実行の際に--enable-sslのオプションを追加し拡張機能を有効にする

mod_sslがmodule内に追加され、httpd.conf内にも記述される

再インストールを実施

