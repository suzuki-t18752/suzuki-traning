# git
```
#wslにて

#ssh keyを作成
ssh-keygen -t rsa  -b 2048 -C 'suzuki@DESKTOP-F5L0LPE:'

#~/.ssh/id_rsa.pubファイルより中身を全てコピーする
cat /.ssh/id_rsa.pub

#https://github.com/settings/ssh にアクセスして[Add SSH key]を押下、タイトルを先ほどコピーしたものをkeyに入力して[Add key]を押下して完了

#接続確認
ssh -T git@github.com

#ユーザーの設定
git config --global user.name "suzuki"
git config --global user.email "suzukit@suzuki.jp"

#devという名前のBranchを作成する
git checkout -b dev

#gitでの管理を開始する
git init

#編集ファイルをステージングに移す
git add .

#編集ファイルをcommitする
git commit -m "20210901~20210910_report"

#リモートアドレスを登録
git remote add origin git@github.com:suzuki-t18752/suzuki-traning.git

#devブランチからGithub上のoriginブランチにpushする
git push -u origin dev

```

# mysql

[ダウンロード先](https://dev.mysql.com/downloads/mysql/)

## 1.インストールまで
```
#パッケージのインストール
[suzuki@localhost /]$ sudo yum install cmake ncurses-devel zlib-devel libaio-devel

#ソースコードを置くディレクトリへ
[suzuki@localhost /]$ cd /usr/local/src

#ソースコードのダウンロード
[suzuki@localhost src]$ sudo curl -L -O --url https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.34.tar.gz

#ファイルの解凍
[suzuki@localhost src]$ sudo tar xvf mysql-5.7.34.tar.gz

#作業ディレクトリへ移動
[suzuki@localhost src]$ cd mysql-5.7.34

#Makefileを作成
[suzuki@localhost mysql-5.7.34]$ sudo cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost

#Makefikeを元にmake installに必要なファイルをコンパイル
[suzuki@localhost mysql-5.7.34]$ sudo make

#インストール実施
[suzuki@localhost mysql-5.7.34]$ sudo make install

```

## 2.設定
```
#作業ディレクトリへ
[suzuki@localhost mysql-5.7.34]$ cd /usr/local/mysql

#mysql用グループの作成
[suzuki@localhost mysql]$ sudo groupadd mysql

#mysql用ユーザーの作成
[suzuki@localhost mysql]$ sudo useradd -m mysql -g mysql

#mysqlユーザーのパスワードを設定
[suzuki@localhost mysql]$ sudo passwd mysql

#パスワード入力を求められるので任意の同じパスワード２回を入力

#データディレクトリを初期化
[suzuki@localhost mysql]$ sudo bin/mysqld --initialize --user=mysql

bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql/ --datadir=/usr/local/mysql/data

2021-09-13T08:19:11.469553Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
2021-09-13T08:19:12.249120Z 0 [Warning] InnoDB: New log files created, LSN=45790
2021-09-13T08:19:12.478014Z 0 [Warning] InnoDB: Creating foreign key constraint system tables.
2021-09-13T08:19:12.580474Z 0 [Warning] No existing UUID has been found, so we assume that this is the first time that this server has been started. Generating a new UUID: 46ef91e1-146b-11ec-84bb-080027744419.
2021-09-13T08:19:12.589277Z 0 [Warning] Gtid table is not ready to be used. Table 'mysql.gtid_executed' cannot be opened.
2021-09-13T08:19:13.031283Z 0 [Warning] CA certificate ca.pem is self signed.
2021-09-13T08:19:13.110827Z 1 [Note] A temporary password is generated for root@localhost: xR#BCpJi#2)I


sudo bin/mysqld --defaults-file=/usr/local/mysql/my.cnf --initialize --user=mysql
```
### データディレクトリ
mysqlサーバーによって管理される情報を格納するディレクトリ

```


```