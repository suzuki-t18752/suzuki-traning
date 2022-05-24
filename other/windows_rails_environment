# windows11にrails環境を構築する

## 1. linux環境の構築
- [参考](https://www.kagoya.jp/howto/it-glossary/develop/wsl2_linux/)
1. wsl(windows for sub syatem for linux)をインストールする
  - コマンドプロンプトを開き下記コマンドを入力する
  ```
  wsl --install
  ```
  - PCの再起動を行う

2. ubuntuをインストールする
  - Microsoft storeでubuntuを検索し、入手ボタンを押下してインストールする
  - インストール後、ubuntuが開くのでユーザー名とパスワードを入力し、設定する(ユーザー名とパスワードはメモしておくこと)
  
3. Windows Terminalをインストールする
  - Microsoft storeでWindows Terminalを検索し、入手ボタンを押下してインストールする
  - Windows Terminalの設定を開き、規定のファイルをubuntuに設定する
  
## 2. docker環境の構築
- [参考](https://sabakunotabito.hatenablog.com/entry/2021/10/03/024348)
1. aptのバージョン確認
```
sudo apt upadte
sudo apt upgrade

suzukit@agrio___orio:~$ sudo apt upgrade
Reading package lists... Done
Building dependency tree
Reading state information... Done
Calculating upgrade... Done
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
```
2. Dockerに必要なパッケージのインストール
```
sudo apt install -y apt-transport-https ca-certificates gnupg-agent software-properties-common

suzukit@agrio___orio:~$ sudo apt install -y apt-transport-https ca-certificates gnupg-agent software-properties-common
Reading package lists... Done
Building dependency tree
Reading state information... Done
Note, selecting 'apt' instead of 'apt-transport-https'
Note, selecting 'gpg-agent' instead of 'gnupg-agent'
apt is already the newest version (2.0.2).
apt set to manually installed.
ca-certificates is already the newest version (20190110ubuntu1).
ca-certificates set to manually installed.
gpg-agent is already the newest version (2.2.19-3ubuntu2).
gpg-agent set to manually installed.
software-properties-common is already the newest version (0.98.9).
software-properties-common set to manually installed.
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
```

3. Dockerの公式GPGキーの取得と確認
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

suzukit@agrio___orio:~$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
OK
suzukit@agrio___orio:~$ sudo apt-key fingerprint 0EBFCD88
pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]
```

4. リポジトリの設定を行う
```
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

suzukit@agrio___orio:~$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
Get:1 https://download.docker.com/linux/ubuntu focal InRelease [57.7 kB]
Get:2 https://download.docker.com/linux/ubuntu focal/stable amd64 Packages [16.7 kB]
Get:3 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Get:4 http://archive.ubuntu.com/ubuntu focal InRelease [265 kB]
Get:5 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [1453 kB]
Get:6 http://archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Get:7 http://security.ubuntu.com/ubuntu focal-security/main Translation-en [250 kB]
Get:8 http://security.ubuntu.com/ubuntu focal-security/main amd64 c-n-f Metadata [10.2 kB]
Get:9 http://security.ubuntu.com/ubuntu focal-security/restricted amd64 Packages [914 kB]
Get:10 http://archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Get:11 http://security.ubuntu.com/ubuntu focal-security/restricted Translation-en [130 kB]
Get:12 http://security.ubuntu.com/ubuntu focal-security/restricted amd64 c-n-f Metadata [520 B]
Get:13 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [703 kB]
Get:14 http://security.ubuntu.com/ubuntu focal-security/universe Translation-en [125 kB]
Get:15 http://security.ubuntu.com/ubuntu focal-security/universe amd64 c-n-f Metadata [14.5 kB]
Get:16 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 Packages [22.2 kB]
Get:17 http://security.ubuntu.com/ubuntu focal-security/multiverse Translation-en [5376 B]
Get:18 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 c-n-f Metadata [512 B]
Get:19 http://archive.ubuntu.com/ubuntu focal/main amd64 Packages [970 kB]
Get:20 http://archive.ubuntu.com/ubuntu focal/main Translation-en [506 kB]
Get:21 http://archive.ubuntu.com/ubuntu focal/main amd64 c-n-f Metadata [29.5 kB]
Get:22 http://archive.ubuntu.com/ubuntu focal/universe amd64 Packages [8628 kB]
Get:23 http://archive.ubuntu.com/ubuntu focal/universe Translation-en [5124 kB]
Get:24 http://archive.ubuntu.com/ubuntu focal/universe amd64 c-n-f Metadata [265 kB]
Get:25 http://archive.ubuntu.com/ubuntu focal/multiverse amd64 Packages [144 kB]
Get:26 http://archive.ubuntu.com/ubuntu focal/multiverse Translation-en [104 kB]
Get:27 http://archive.ubuntu.com/ubuntu focal/multiverse amd64 c-n-f Metadata [9136 B]
Get:28 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [1793 kB]
Get:29 http://archive.ubuntu.com/ubuntu focal-updates/main Translation-en [330 kB]
Get:30 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 c-n-f Metadata [15.2 kB]
Get:31 http://archive.ubuntu.com/ubuntu focal-updates/restricted amd64 Packages [976 kB]
Get:32 http://archive.ubuntu.com/ubuntu focal-updates/restricted Translation-en [139 kB]
Get:33 http://archive.ubuntu.com/ubuntu focal-updates/restricted amd64 c-n-f Metadata [520 B]
Get:34 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [924 kB]
Get:35 http://archive.ubuntu.com/ubuntu focal-updates/universe Translation-en [207 kB]
Get:36 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 c-n-f Metadata [20.7 kB]
Get:37 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [24.4 kB]
Get:38 http://archive.ubuntu.com/ubuntu focal-updates/multiverse Translation-en [7336 B]
Get:39 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 c-n-f Metadata [596 B]
Get:40 http://archive.ubuntu.com/ubuntu focal-backports/main amd64 Packages [68.1 kB]
Get:41 http://archive.ubuntu.com/ubuntu focal-backports/main Translation-en [10.9 kB]
Get:42 http://archive.ubuntu.com/ubuntu focal-backports/main amd64 c-n-f Metadata [980 B]
Get:43 http://archive.ubuntu.com/ubuntu focal-backports/restricted amd64 c-n-f Metadata [116 B]
Get:44 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 Packages [26.8 kB]
Get:45 http://archive.ubuntu.com/ubuntu focal-backports/universe Translation-en [15.9 kB]
Get:46 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 c-n-f Metadata [860 B]
Get:47 http://archive.ubuntu.com/ubuntu focal-backports/multiverse amd64 c-n-f Metadata [116 B]
Fetched 24.6 MB in 6s (3929 kB/s)
Reading package lists... Done
```

5. Dockerのインストール
```
$ sudo apt update
$ sudo apt install -y docker-ce docker-ce-cli containerd.io
$ docker --version

suzukit@agrio___orio:~$ sudo apt update
Hit:1 https://download.docker.com/linux/ubuntu focal InRelease
Hit:2 http://archive.ubuntu.com/ubuntu focal InRelease
Hit:3 http://security.ubuntu.com/ubuntu focal-security InRelease
Hit:4 http://archive.ubuntu.com/ubuntu focal-updates InRelease
Hit:5 http://archive.ubuntu.com/ubuntu focal-backports InRelease
Reading package lists... Done
Building dependency tree
Unpacking docker-ce-cli (5:20.10.16~3-0~ubuntu-focal) ...
Selecting previously unselected package docker-ce.
Preparing to unpack .../2-docker-ce_5%3a20.10.16~3-0~ubuntu-focal_amd64.deb ...
Unpacking docker-ce (5:20.10.16~3-0~ubuntu-focal) ...
Selecting previously unselected package docker-ce-rootless-extras.
Preparing to unpack .../3-docker-ce-rootless-extras_5%3a20.10.16~3-0~ubuntu-focal_amd64.deb ...
Unpacking docker-ce-rootless-extras (5:20.10.16~3-0~ubuntu-focal) ...
Selecting previously unselected package docker-scan-plugin.
Preparing to unpack .../4-docker-scan-plugin_0.17.0~ubuntu-focal_amd64.deb ...
Unpacking docker-scan-plugin (0.17.0~ubuntu-focal) ...
Selecting previously unselected package slirp4netns.
Preparing to unpack .../5-slirp4netns_0.4.3-1_amd64.deb ...
Unpacking slirp4netns (0.4.3-1) ...
Setting up slirp4netns (0.4.3-1) ...
Setting up docker-scan-plugin (0.17.0~ubuntu-focal) ...
Setting up containerd.io (1.6.4-1) ...
Created symlink /etc/systemd/system/multi-user.target.wants/containerd.service → /lib/systemd/system/containerd.service.
Setting up docker-ce-cli (5:20.10.16~3-0~ubuntu-focal) ...
Setting up pigz (2.4-1) ...
Setting up docker-ce-rootless-extras (5:20.10.16~3-0~ubuntu-focal) ...
Setting up docker-ce (5:20.10.16~3-0~ubuntu-focal) ...
Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /lib/systemd/system/docker.service.
Created symlink /etc/systemd/system/sockets.target.wants/docker.socket → /lib/systemd/system/docker.socket.
invoke-rc.d: could not determine current runlevel
Processing triggers for systemd (245.4-4ubuntu3) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9) ...
suzukit@agrio___orio:~$ docker --version
Docker version 20.10.16, build aa7e414
```
6. composeのバージョンアップ
- バージョン確認
```
apt list | grep docker-compose

suzukit@agrio___orio:~$ apt list | grep docker-compose
WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
docker-compose-plugin/focal 2.5.0~ubuntu-focal amd64
docker-compose/focal 1.25.0-1 all
```
- バージョンがdocker-compose/focal 1.25.0-1 allと表示されていたらそのまま下記コマンドを実行してdocker-composeをインストール
```
sudo apt install docker-compose
docker-compose --version
```

7. dockerの起動、確認
```
suzukit@agrio___orio:~$ sudo service docker start
 * Starting Docker: docker                                                                                       [ OK ]
suzukit@agrio___orio:~$ service docker status
 * Docker is running
 ```
 
 8. dockerの動作確認
 ```
 suzukit@agrio___orio:~$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
2db29710123e: Pull complete
Digest: sha256:80f31da1ac7b312ba29d65080fddf797dd76acfb870e677f390d5acba9741b17
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```
- dockerサービスのコマンド一覧と停止
```
suzukit@agrio___orio:~$ sudo service docker help
Usage: service docker {start|stop|restart|status}
suzukit@agrio___orio:~$ sudo service docker stop
 * Stopping Docker: docker
```

- dockerにmysqlを入れる
```
事前にdockerを起動しておくこと
docker pull --platform linux/x86_64 mysql:5.7

suzukit@agrio___orio:~$ docker pull --platform linux/x86_64 mysql:5.7
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
suzukit@agrio___orio:~$ sudo service docker start
[sudo] password for suzukit:
 * Starting Docker: docker                                                                                       [ OK ]
suzukit@agrio___orio:~$ sudo docker pull --platform linux/x86_64 mysql:5.7
5.7: Pulling from library/mysql
c32ce6654453: Pull complete
415d08ee031a: Pull complete
7a38fec2542f: Pull complete
352881ee8fe9: Pull complete
b8e20da291b6: Pull complete
66c2a8cc1999: Pull complete
d3a3a8e49878: Pull complete
172aabfba65c: Pull complete
fea17d0b1d1e: Pull complete
9e875a69819c: Pull complete
ff8480c408a2: Pull complete
Digest: sha256:7815f2f82a78eb5e5ebccf6ec6352d94691faf1232e80335ab36a4dfdc0b6723
Status: Downloaded newer image for mysql:5.7
docker.io/library/mysql:5.7
```

## 2.5. git
```
suzukit@agrio___orio:~$ git --version
git version 2.25.1
```

## 3. ruby, railsのインストール
```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
必要に応じてgccのインストールを行う
sudo apt install build-essential

cd ~/.rbenv && src/configure && make -C src
vi ~/.bashrc
+ export PATH="$HOME/.rbenv/bin:$HOME/local/go/bin:$HOME/bin:$PATH"
+ eval "$(rbenv init -)"

exec -l $SHELL
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv install 2.7.5
rbenv local 2.7.5
gem install bundler




suzukit@agrio___orio:~$ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
Cloning into '/home/suzukit/.rbenv'...
remote: Enumerating objects: 3013, done.
remote: Counting objects: 100% (117/117), done.
remote: Compressing objects: 100% (66/66), done.
remote: Total 3013 (delta 62), reused 91 (delta 51), pack-reused 2896
Receiving objects: 100% (3013/3013), 606.48 KiB | 3.09 MiB/s, done.
Resolving deltas: 100% (1871/1871), done.
suzukit@agrio___orio:~$ cd ~/.rbenv && src/configure && make -C src
warning: gcc not found; using CC=cc
aborted: compiler not found: cc
suzukit@agrio___orio:~/.rbenv$ ls -l
total 52
-rw-r--r-- 1 suzukit suzukit  3390 May 24 21:47 CODE_OF_CONDUCT.md
-rw-r--r-- 1 suzukit suzukit  1058 May 24 21:47 LICENSE
-rw-r--r-- 1 suzukit suzukit 18393 May 24 21:47 README.md
drwxr-xr-x 2 suzukit suzukit  4096 May 24 21:47 bin
drwxr-xr-x 2 suzukit suzukit  4096 May 24 21:47 completions
suzukit@agrio___orio:~/.rbenv$ make -C src

Command 'make' not found, but can be installed with:

sudo apt install make        # version 4.2.1-1.2, or
sudo apt install make-guile  # version 4.2.1-1.2

suzukit@agrio___orio:~/.rbenv$ sudo apt install make
[sudo] password for suzukit:
Reading package lists... Done
Building dependency tree
Reading state information... Done
Suggested packages:
  make-doc
The following NEW packages will be installed:
  make
0 upgraded, 1 newly installed, 0 to remove and 265 not upgraded.
Need to get 162 kB of archives.
After this operation, 393 kB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu focal/main amd64 make amd64 4.2.1-1.2 [162 kB]
Fetched 162 kB in 1s (138 kB/s)
Selecting previously unselected package make.
(Reading database ... 32332 files and directories currently installed.)
Preparing to unpack .../make_4.2.1-1.2_amd64.deb ...
Unpacking make (4.2.1-1.2) ...
Setting up make (4.2.1-1.2) ...
Processing triggers for man-db (2.9.1-1) ...
suzukit@agrio___orio:~/.rbenv$ make -C src
make: Entering directory '/home/suzukit/.rbenv/src'
make: *** No targets specified and no makefile found.  Stop.
make: Leaving directory '/home/suzukit/.rbenv/src'
suzukit@agrio___orio:~/.rbenv$ src/configure
warning: gcc not found; using CC=cc
aborted: compiler not found: cc
suzukit@agrio___orio:~/.rbenv$ sudo apt install build-essential
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  binutils binutils-common binutils-x86-64-linux-gnu cpp cpp-9 dpkg-dev fakeroot g++ g++-9 gcc gcc-10-base gcc-9
  gcc-9-base libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libasan5 libatomic1 libbinutils
  libc-dev-bin libc6 libc6-dev libcc1-0 libcrypt-dev libctf-nobfd0 libctf0 libdpkg-perl libfakeroot
  libfile-fcntllock-perl libgcc-9-dev libgcc-s1 libgomp1 libisl22 libitm1 liblsan0 libmpc3 libquadmath0
  libstdc++-9-dev libstdc++6 libtsan0 libubsan1 linux-libc-dev manpages-dev
Suggested packages:
  binutils-doc cpp-doc gcc-9-locales debian-keyring g++-multilib g++-9-multilib gcc-9-doc gcc-multilib autoconf
  automake libtool flex bison gdb gcc-doc gcc-9-multilib glibc-doc bzr libstdc++-9-doc
The following NEW packages will be installed:
  binutils binutils-common binutils-x86-64-linux-gnu build-essential cpp cpp-9 dpkg-dev fakeroot g++ g++-9 gcc gcc-9
  gcc-9-base libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl libasan5 libatomic1 libbinutils
  libc-dev-bin libc6-dev libcc1-0 libcrypt-dev libctf-nobfd0 libctf0 libdpkg-perl libfakeroot libfile-fcntllock-perl
  libgcc-9-dev libgomp1 libisl22 libitm1 liblsan0 libmpc3 libquadmath0 libstdc++-9-dev libtsan0 libubsan1
  linux-libc-dev manpages-dev
The following packages will be upgraded:
  gcc-10-base libc6 libgcc-s1 libstdc++6
4 upgraded, 40 newly installed, 0 to remove and 261 not upgraded.
Need to get 48.5 MB of archives.
After this operation, 202 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 gcc-10-base amd64 10.3.0-1ubuntu1~20.04 [20.2 kB]
Get:2 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libstdc++6 amd64 10.3.0-1ubuntu1~20.04 [501 kB]
Get:3 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libgcc-s1 amd64 10.3.0-1ubuntu1~20.04 [41.8 kB]
Get:4 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libc6 amd64 2.31-0ubuntu9.9 [2722 kB]
Get:5 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 binutils-common amd64 2.34-6ubuntu1.3 [207 kB]
Get:6 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libbinutils amd64 2.34-6ubuntu1.3 [474 kB]
Get:7 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libctf-nobfd0 amd64 2.34-6ubuntu1.3 [47.4 kB]
Get:8 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libctf0 amd64 2.34-6ubuntu1.3 [46.6 kB]
Get:9 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 binutils-x86-64-linux-gnu amd64 2.34-6ubuntu1.3 [1613 kB]
Get:10 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 binutils amd64 2.34-6ubuntu1.3 [3380 B]
Get:11 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libc-dev-bin amd64 2.31-0ubuntu9.9 [71.8 kB]
Get:12 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 linux-libc-dev amd64 5.4.0-110.124 [1115 kB]
Get:13 http://archive.ubuntu.com/ubuntu focal/main amd64 libcrypt-dev amd64 1:4.4.10-10ubuntu4 [104 kB]
Get:14 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libc6-dev amd64 2.31-0ubuntu9.9 [2519 kB]
Get:15 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 gcc-9-base amd64 9.4.0-1ubuntu1~20.04.1 [19.4 kB]
Get:16 http://archive.ubuntu.com/ubuntu focal/main amd64 libisl22 amd64 0.22.1-1 [592 kB]
Get:17 http://archive.ubuntu.com/ubuntu focal/main amd64 libmpc3 amd64 1.1.0-1 [40.8 kB]
Get:18 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 cpp-9 amd64 9.4.0-1ubuntu1~20.04.1 [7500 kB]
Get:19 http://archive.ubuntu.com/ubuntu focal/main amd64 cpp amd64 4:9.3.0-1ubuntu2 [27.6 kB]
Setting up libbinutils:amd64 (2.34-6ubuntu1.3) ...
Setting up libc-dev-bin (2.31-0ubuntu9.9) ...
Setting up libalgorithm-diff-xs-perl (0.04-6) ...
Setting up libcc1-0:amd64 (10.3.0-1ubuntu1~20.04) ...
Setting up liblsan0:amd64 (10.3.0-1ubuntu1~20.04) ...
Setting up libitm1:amd64 (10.3.0-1ubuntu1~20.04) ...
Setting up gcc-9-base:amd64 (9.4.0-1ubuntu1~20.04.1) ...
Setting up libalgorithm-merge-perl (0.08-3) ...
Setting up libtsan0:amd64 (10.3.0-1ubuntu1~20.04) ...
Setting up libctf0:amd64 (2.34-6ubuntu1.3) ...
Setting up libasan5:amd64 (9.4.0-1ubuntu1~20.04.1) ...
Setting up cpp-9 (9.4.0-1ubuntu1~20.04.1) ...
Setting up libc6-dev:amd64 (2.31-0ubuntu9.9) ...
Setting up binutils-x86-64-linux-gnu (2.34-6ubuntu1.3) ...
Setting up binutils (2.34-6ubuntu1.3) ...
Setting up dpkg-dev (1.19.7ubuntu3) ...
Setting up libgcc-9-dev:amd64 (9.4.0-1ubuntu1~20.04.1) ...
Setting up cpp (4:9.3.0-1ubuntu2) ...
Setting up gcc-9 (9.4.0-1ubuntu1~20.04.1) ...
Setting up libstdc++-9-dev:amd64 (9.4.0-1ubuntu1~20.04.1) ...
Setting up gcc (4:9.3.0-1ubuntu2) ...
Setting up g++-9 (9.4.0-1ubuntu1~20.04.1) ...
Setting up g++ (4:9.3.0-1ubuntu2) ...
update-alternatives: using /usr/bin/g++ to provide /usr/bin/c++ (c++) in auto mode
Setting up build-essential (12.8ubuntu1.1) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9) ...
suzukit@agrio___orio:~/.rbenv$ src/configure
suzukit@agrio___orio:~/.rbenv$ make -C src
make: Entering directory '/home/suzukit/.rbenv/src'
gcc -fPIC     -c -o realpath.o realpath.c
gcc -shared -Wl,-soname,../libexec/rbenv-realpath.dylib  -o ../libexec/rbenv-realpath.dylib realpath.o
make: Leaving directory '/home/suzukit/.rbenv/src'
suzukit@agrio___orio:~/.rbenv$ ls -l
total 52
-rw-r--r-- 1 suzukit suzukit  3390 May 24 21:47 CODE_OF_CONDUCT.md
-rw-r--r-- 1 suzukit suzukit  1058 May 24 21:47 LICENSE
-rw-r--r-- 1 suzukit suzukit 18393 May 24 21:47 README.md
drwxr-xr-x 2 suzukit suzukit  4096 May 24 21:47 bin
drwxr-xr-x 2 suzukit suzukit  4096 May 24 21:47 completions
drwxr-xr-x 2 suzukit suzukit  4096 May 24 22:04 libexec
drwxr-xr-x 3 suzukit suzukit  4096 May 24 21:47 rbenv.d
drwxr-xr-x 2 suzukit suzukit  4096 May 24 22:04 src
drwxr-xr-x 3 suzukit suzukit  4096 May 24 21:47 test
suzukit@agrio___orio:~/.rbenv$ gcc --version
gcc (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

suzukit@agrio___orio:~/.rbenv$ make --version
GNU Make 4.2.1
Built for x86_64-pc-linux-gnu
Copyright (C) 1988-2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
suzukit@agrio___orio:~/.rbenv$ exec -l $SHELL
suzukit@agrio___orio:~/.rbenv$ mkdir -p "$(rbenv root)"/plugins

Command 'rbenv' not found, but can be installed with:

sudo apt install rbenv

mkdir: cannot create directory ‘/plugins’: Permission denied
suzukit@agrio___orio:~/.rbenv$ sudo apt install rbenv
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  fonts-lato icu-devtools javascript-common libicu-dev libicu66 libjs-jquery libncurses-dev libreadline-dev libruby2.7
  libsqlite3-0 libsqlite3-dev libssl-dev libssl1.1 libxml2 libxml2-dev libxslt1-dev rake ruby ruby-build ruby-minitest
  ruby-net-telnet ruby-power-assert ruby-test-unit ruby-xmlrpc ruby2.7 rubygems-integration unzip zip zlib1g
  zlib1g-dev
Suggested packages:
  apache2 | lighttpd | httpd icu-doc ncurses-doc readline-doc sqlite3-doc libssl-doc pkg-config ri ruby-dev autoconf
  automake bison libtool bundler
The following NEW packages will be installed:
  fonts-lato icu-devtools javascript-common libicu-dev libjs-jquery libncurses-dev libreadline-dev libruby2.7
  libsqlite3-dev libssl-dev libxml2-dev libxslt1-dev rake rbenv ruby ruby-build ruby-minitest ruby-net-telnet
  ruby-power-assert ruby-test-unit ruby-xmlrpc ruby2.7 rubygems-integration unzip zip zlib1g-dev
The following packages will be upgraded:
  libicu66 libsqlite3-0 libssl1.1 libxml2 zlib1g
5 upgraded, 26 newly installed, 0 to remove and 256 not upgraded.
Need to get 31.9 MB of archives.
After this operation, 98.3 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://archive.ubuntu.com/ubuntu focal/main amd64 fonts-lato all 2.0-2 [2698 kB]
Get:2 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 zlib1g amd64 1:1.2.11.dfsg-2ubuntu1.3 [53.8 kB]
Get:3 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libicu66 amd64 66.1-2ubuntu2.1 [8515 kB]
Get:4 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libsqlite3-0 amd64 3.31.1-4ubuntu0.3 [549 kB]
Get:5 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libssl1.1 amd64 1.1.1f-1ubuntu2.13 [1321 kB]
Get:6 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 libxml2 amd64 2.9.10+dfsg-5ubuntu0.20.04.3 [640 kB]
Setting up libsqlite3-0:amd64 (3.31.1-4ubuntu0.3) ...
Setting up rubygems-integration (1.16) ...
Setting up libreadline-dev:amd64 (8.0-4) ...
Setting up ruby-minitest (5.13.0-1) ...
Setting up zip (3.0-11build1) ...
Setting up libsqlite3-dev:amd64 (3.31.1-4ubuntu0.3) ...
Setting up ruby-test-unit (3.3.5-1) ...
Setting up ruby-net-telnet (0.1.1-2) ...
Setting up libssl-dev:amd64 (1.1.1f-1ubuntu2.13) ...
Setting up icu-devtools (66.1-2ubuntu2.1) ...
Setting up zlib1g-dev:amd64 (1:1.2.11.dfsg-2ubuntu1.3) ...
Setting up libjs-jquery (3.3.1~dfsg-3) ...
Setting up libicu-dev:amd64 (66.1-2ubuntu2.1) ...
Setting up ruby-xmlrpc (0.3.0-2) ...
Setting up libxml2:amd64 (2.9.10+dfsg-5ubuntu0.20.04.3) ...
Setting up ruby-build (20170726-1) ...
Setting up libxml2-dev:amd64 (2.9.10+dfsg-5ubuntu0.20.04.3) ...
Setting up libxslt1-dev:amd64 (1.1.34-4) ...
Setting up rake (13.0.1-4) ...
Setting up libruby2.7:amd64 (2.7.0-5ubuntu1.6) ...
Setting up ruby2.7 (2.7.0-5ubuntu1.6) ...
Setting up ruby (1:2.7+1) ...
Setting up rbenv (1.1.1-1) ...
Processing triggers for install-info (6.7.0.dfsg.2-5) ...
Processing triggers for mime-support (3.64ubuntu1) ...
Processing triggers for libc-bin (2.31-0ubuntu9) ...
Processing triggers for man-db (2.9.1-1) ...
suzukit@agrio___orio:~/.rbenv$ mkdir -p "$(rbenv root)"/plugins
suzukit@agrio___orio:~/.rbenv$ git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
Cloning into '/home/suzukit/.rbenv/plugins/ruby-build'...
remote: Enumerating objects: 12207, done.
remote: Counting objects: 100% (900/900), done.
remote: Compressing objects: 100% (311/311), done.
remote: Total 12207 (delta 612), reused 778 (delta 532), pack-reused 11307
Receiving objects: 100% (12207/12207), 2.54 MiB | 10.76 MiB/s, done.
Resolving deltas: 100% (8079/8079), done.
suzukit@agrio___orio:~/.rbenv$ rbenv install 2.7.5
Downloading ruby-2.7.5.tar.bz2...
-> https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.5.tar.bz2
Installing ruby-2.7.5...
Installed ruby-2.7.5 to /home/suzukit/.rbenv/versions/2.7.5
```
