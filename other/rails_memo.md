# railsのメモ
## 日付の計算
```
[1] pry(main)> Time.now + 1.day
=> 2022-07-01 14:14:25.8902775 +0900
[2] pry(main)> Time.now + 2.days
=> 2022-07-02 14:14:30.4614213 +0900
[3] pry(main)> Time.now + 2.day
=> 2022-07-02 14:14:57.1363041 +0900
[4] pry(main)> Time.now + 2.days
=> 2022-07-02 14:15:01.2179815 +0900
[6] pry(main)> Time.now + 1.second
=> 2022-06-30 14:15:16.3675628 +0900
[7] pry(main)> Time.now + 1.seconds
=> 2022-06-30 14:15:17.8957472 +0900
[11] pry(main)> Time.now + 1.minute
=> 2022-06-30 14:16:37.5275331 +0900
[12] pry(main)> Time.now + 2.minute
=> 2022-06-30 14:17:42.3341992 +0900
[13] pry(main)> Time.now + 1.month
=> 2022-07-30 14:15:49.2873874 +0900
```
