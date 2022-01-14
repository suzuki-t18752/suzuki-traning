## rspec
- 実行順序
```
puts “1”
describe “describe” do
  puts “2”
  context “context” do
    puts “3”
    it “it” do
      puts “4”
    end
    puts “5”
  end
  puts “6”
  context “context” do
  puts “7”
    it “it” do
      puts “8”
    end
    puts “9”
  end
  puts “10”
end
puts “11”

1
2
3
5
6
7
9
10
11
4
8
```

1. describe
2. context（この中にletがあればそれを呼ぶ）
3. let!
4. before
5. it
