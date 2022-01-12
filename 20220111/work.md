## aws redis
- redisはマスター・スレーブ型レプリケーション方式をとっている
- awsではマスターをprimary,スレーブをreplicaというノードで分けている
- primaryは書き込み、読み込み共に行える
- replicaは読み込みのみ
- primary側で障害が発生するとreplica側をprimaryに昇格させる設定がある
  - 接続がうまく出来なかったり、読み込み専用のreplicaに書き込みにいてしまったりするので一時的にエラーが出る
  ```
  Redis::TimeoutError
  Redis::CommandError (READONLY You can't write against a read only replica.):
  Redis::ConnectionError (Connection lost (ECONNRESET)):
  ```
  - 障害の発生したprimaryは障害復旧後、replicaとして復旧する


## ruby バージョンアップ
```
suzuki@DESKTOP-G7N3ULO:~/.rbenv$ git -C /home/suzuki/.rbenv/plugins/ruby-build pull
remote: Enumerating objects: 119, done.
remote: Counting objects: 100% (119/119), done.
remote: Compressing objects: 100% (75/75), done.
remote: Total 119 (delta 51), reused 77 (delta 32), pack-reused 0
Receiving objects: 100% (119/119), 50.57 KiB | 12.64 MiB/s, done.
Resolving deltas: 100% (51/51), completed with 6 local objects.
From https://github.com/rbenv/ruby-build
   e390941..cdc215e  master     -> origin/master
 * [new tag]         v20211019  -> v20211019
 * [new tag]         v20211109  -> v20211109
 * [new tag]         v20211124  -> v20211124
 * [new tag]         v20211201  -> v20211201
 * [new tag]         v20211203  -> v20211203
 * [new tag]         v20211225  -> v20211225
 * [new tag]         v20211227  -> v20211227
Updating e390941..cdc215e
Fast-forward
 .github/ISSUE_TEMPLATE/bug.md               | 16 ++++++++++++++++
 .github/ISSUE_TEMPLATE/config.yml           |  8 ++++++++
 .github/ISSUE_TEMPLATE/enhancement.md       |  8 ++++++++
 bin/ruby-build                              |  2 +-
 script/update-cruby                         |  2 +-
 share/ruby-build/2.6.9                      |  2 ++
 share/ruby-build/2.7.5                      |  2 ++
 share/ruby-build/3.0.3                      |  2 ++
 share/ruby-build/3.1.0                      |  2 ++
 share/ruby-build/3.1.0-dev                  |  2 +-
 share/ruby-build/3.1.0-preview1             |  2 ++
 share/ruby-build/3.2.0-dev                  |  2 ++
 share/ruby-build/jruby-9.2.20.0             |  2 ++
 share/ruby-build/jruby-9.2.20.1             |  2 ++
 share/ruby-build/jruby-9.3.1.0              |  2 ++
 share/ruby-build/jruby-9.3.2.0              |  2 ++
 share/ruby-build/truffleruby+graalvm-21.3.0 | 17 +++++++++++++++++
 share/ruby-build/truffleruby-21.3.0         | 17 +++++++++++++++++
 share/ruby-build/yjit-dev                   |  2 --
 19 files changed, 89 insertions(+), 5 deletions(-)
 create mode 100644 .github/ISSUE_TEMPLATE/bug.md
 create mode 100644 .github/ISSUE_TEMPLATE/config.yml
 create mode 100644 .github/ISSUE_TEMPLATE/enhancement.md
 create mode 100644 share/ruby-build/2.6.9
 create mode 100644 share/ruby-build/2.7.5
 create mode 100644 share/ruby-build/3.0.3
 create mode 100644 share/ruby-build/3.1.0
 create mode 100644 share/ruby-build/3.1.0-preview1
 create mode 100644 share/ruby-build/3.2.0-dev
 create mode 100644 share/ruby-build/jruby-9.2.20.0
 create mode 100644 share/ruby-build/jruby-9.2.20.1
 create mode 100644 share/ruby-build/jruby-9.3.1.0
 create mode 100644 share/ruby-build/jruby-9.3.2.0
 create mode 100644 share/ruby-build/truffleruby+graalvm-21.3.0
 create mode 100644 share/ruby-build/truffleruby-21.3.0
 delete mode 100644 share/ruby-build/yjit-dev
suzuki@DESKTOP-G7N3ULO:~/.rbenv$ rbenv install --list
2.6.9
2.7.5
3.0.3
3.1.0
jruby-9.3.2.0
mruby-3.0.0
rbx-5.0
truffleruby-21.3.0
truffleruby+graalvm-21.3.0

Only latest stable releases for each Ruby implementation are shown.
Use 'rbenv install --list-all / -L' to show all local versions.
suzuki@DESKTOP-G7N3ULO:~/.rbenv$ rbenv install 2.7.5
Downloading ruby-2.7.5.tar.bz2...
-> https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.5.tar.bz2
Installing ruby-2.7.5...
Installed ruby-2.7.5 to /home/suzuki/.rbenv/versions/2.7.5

suzuki@DESKTOP-G7N3ULO:~/.rbenv$ ruby -v
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux]
suzuki@DESKTOP-G7N3ULO:~/.rbenv$ rbenv local 2.7.5
suzuki@DESKTOP-G7N3ULO:~/.rbenv$ ruby -v
ruby 2.7.5p203 (2021-11-24 revision f69aeb8314) [x86_64-linux]
```




```
suzuki@DESKTOP-G7N3ULO:~/suzuki$ bundle install
~~
~~
~~
Post-install message from icalendar:
ActiveSupport is required for TimeWithZone support, but not required for general use.
Post-install message from ruby-graphviz:

You need to install GraphViz (https://graphviz.org) to use this Gem.

For more information about Ruby-Graphviz :
* Doc: https://rdoc.info/github/glejeune/Ruby-Graphviz
* Sources: https://github.com/glejeune/Ruby-Graphviz
* Issues: https://github.com/glejeune/Ruby-Graphviz/issues
  Post-install message from rubyzip:
RubyZip 3.0 is coming!
**********************

The public API of some Rubyzip classes has been modernized to use named
parameters for optional arguments. Please check your usage of the
following classes:
  * `Zip::File`
  * `Zip::Entry`
  * `Zip::InputStream`
  * `Zip::OutputStream`

Please ensure that your Gemfiles and .gemspecs are suitably restrictive
to avoid an unexpected breakage when 3.0 is released (e.g. ~> 2.3.0).
See https://github.com/rubyzip/rubyzip for details. The Changelog also
lists other enhancements and bugfixes that have been implemented since
version 2.3.0.
```
