# ※全体の作業手順は20210907ディレクトリの作業.mdを参照

# apacheのインストール
## 概要
webサーバーソフトウェアの１つ

## インストール手順 [インストール手順](http://httpd.apache.org/docs/2.4/install.html)

## 1. ソースコードをダウンロードする

[apacheソースコードインストール先](http://httpd.apache.org/download.cgi)

[suzuki@localhost src]$ cd /usr/srcにてファイルを置くディレクトリへ移動

→[suzuki@localhost src]$ sudo curl -O --url https://dlcdn.apache.org//httpd/httpd-2.4.48.tar.gz にてファイルのダウンロードする

→[suzuki@localhost src]$ sudo tar xvf httpd-2.4.48.tar.gzを実行しファイルを解凍する

### tar.gz
「tar」コマンドでまとめたアーカイブファイルを「gzip」コマンドで圧縮した圧縮ファイル

### アーカイブファイル
複数のファイルをまとめて一つのファイルへ変換したファイルの事

### 圧縮、解凍
圧縮とはデータの内容 (意味) を変えずに、そのサイズを小さくすることです。反対に圧縮ソフトなどでサイズの小さなファイルに変換されたデータを、元の状態に復元することを解凍もしくは展開と言う

## 2. APRのダウンロード、インストール

### APRのインストール理由
apacheの./configure実行時に下記エラーが発生する為  
checking for APR... no  
configure: error: APR not found.  Please read the documentation.

### 概要  
OSとソフトウェアの間でOSなどの環境の違いを吸収するAPI。他のOSに一般的にある機能が存在しないOSでは、APRが代替を提供する
[APRダウンロード先](http://apr.apache.org/download.cgi)

### APRのダウンロード、インストール手順  
[suzuki@localhost /]$ cd /usr/srcにてファイルを置くディレクトリへ移動

→[suzuki@localhost src]$ sudo curl -O --url https://dlcdn.apache.org//apr/apr-1.7.0.tar.gz にてファイルのダウンロードする

→[suzuki@localhost src]$ tar xvf apr-1.7.0.tar.gzにてファイルを解凍

→[suzuki@localhost src]$ cd apr-1.7.0にて作業ディレクトリへ移動

→[suzuki@localhost apr-1.7.0]$ sudo ./configure --prefix=/usr/local/apr/apr-1.7.0にてMakefileを作成

- .configureコマンド
Makefileを作成する

--prefixにて特定のディレクトリにファイルの作成を行える

→[suzuki@localhost apr-1.7.0]$ sudo make にてMakefikeを元にmake installに必要なファイルをコンパイル

→[suzuki@localhost apr-1.7.0]$ sudo make install にてインストール実施

### apr-utilのダウンロード、インストール手順  
[suzuki@localhost src]$ cd /usr/srcにてファイルを置くディレクトリへ移動

→[suzuki@localhost src]$ sudo curl -O --url https://dlcdn.apache.org//apr/apr-util-1.6.1.tar.gz にてファイルのダウンロードする

→[suzuki@localhost src]$ tar xvf apr-util-1.6.1.tar.gzにてファイルを解凍

→[suzuki@localhost apr-util-1.6.1]$ cd apr-util-1.6.1にて作業ディレクトリへ移動

→[suzuki@localhost apr-util-1.6.1]$ sudo ./configure --prefix=/usr/local/apr-util/apr-util-1.6.1 --with-apr=/usr/local/apr/apr-1.7.0にてMakefileを作成

→[suzuki@localhost apr-util-1.6.1]$ sudo make にてMakefikeを元にmake installに必要なファイルをコンパイル

→[suzuki@localhost apr-util-1.6.1]$ sudo make install にてインストール実施


## 3. apacheの設定

[suzuki@localhost src]$ cd httpd-2.4.48にて作業ディレクトリへ移動

→[suzuki@localhost httpd-2.4.48]$ sudo ./configure --prefix=/usr/local/httpd/httpd-2.4.48 --with-apr=/usr/local/apr/apr-1.7.0 --with-apr-util=/usr/local/apr-util/apr-util-1.6.1

### --with-apr=/usr/local/apr/apr-1.7.0 --with-apr-util=/usr/local/apr-util/apr-util-1.6.1を付けることでaprとapr-utilのインストール先を参照する

[エラー](https://yohei-a.hatenablog.jp/entry/20120809/1344489131)

→[suzuki@localhost httpd-2.4.48]$ sudo make にてMakefikeを元にmake installに必要なファイルをコンパイル

→[suzuki@localhost httpd-2.4.48]$ sudo make install にてインストール実施

## 4. apacheの起動、確認

[suzuki@localhost httpd-2.4.48]$ sudo /usr/local/httpd/httpd-2.4.48/bin/apachectl start  

上記コマンドを実行し下記画面が表示されれば設定完了  
![](./apache起動完了.png)

## アンインストール手順

- make uninstallが実行可能な場合は実行して完了

- make uninstallが使えない場合はMakefile内を閲覧し、makeinstallにて作成された
ファイル等を削除する

sudo rm -Rf ファイル名　でディレクトリを削除する
- -R ディレクトリ削除
- -f エラーメッセージを表示しない(ディレクトリ削除時にディレクトリ内にファイルがあるとエラーが表示され削除できない)

--prefixにてディレクトリを指定していればディレクトリをまとめて削除すればいい