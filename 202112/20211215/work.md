## ruby の　&&
https://qiita.com/wann/items/3f4dd3f44a6c6ff8e037
[20] pry(main)> nil && 1
=> nil
[21] pry(main)> nil &&
[21] pry(main)* nil && s
=> nil
[22] pry(main)> nil && 2
=> nil
[23] pry(main)> nil && 2
=> nil
[24] pry(main)> 2 && 2
=> 2
[25] pry(main)> 2 && 4
=> 4
[26] pry(main)> if nil && nil
[26] pry(main)*   if nil && nil
[26] pry(main)> nil && nil ?
[26] pry(main)*
[26] pry(main)>
[26] pry(main)>
[26] pry(main)>
[26] pry(main)> nil && nil ? 1 : 2
=> 2
[27] pry(main)> nil && 1 ? 1 : 2
=> 2
[28] pry(main)> 2 && 1 ? 1 : 2
=> 1
[29] pry(main)> 2 && 1 ? 100 : 200
=> 100
[30] pry(main)> 2 && nil ? 100 : 200
=> 200
[31] pry(main)> nil && nil ? 100 : 200
=> 200
[32] pry(main)> !(nil && nil) ? 100 : 200
=> 100
[33] pry(main)> !(nil && "") ? 100 : 200
(pry):34: warning: string literal in condition
=> 100
[34] pry(main)> !(nil && '') ? 100 : 200
(pry):35: warning: string literal in condition
=> 100
[35] pry(main)> !(nil && 0) ? 100 : 200
=> 100
[36] pry(main)> !(0 && 0) ? 100 : 200
=> 200
[37] pry(main)> !(0 && 1) ? 100 : 200
=> 200
[38] pry(main)> !(1 && 1) ? 100 : 200
