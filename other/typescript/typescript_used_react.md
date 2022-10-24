# typesctiptでReactを使う

## Reactとは
- ReactはFacebook社が開発した、ウェブアプリケーションのUIを作るためのパッケージ
- 使う理由
  - UIが複雑になるとReactなしではコードの記述量が増大したり、可読性が悪くなったりと難易度が上がり
    - UIが今どのような状態なのかを管理するのは、プログラマが把握しきれない複雑さになる
    - 複雑なUIやインタラクションを短く簡潔に読みやすく書けるようになり、状態の管理も分かりやすくなる
- 特徴
  - 仮想DOM
    - DOM(document object model)
      - HTMLをJavaScriptから参照・操作する仕組み
      - DOMはHTMLを操作するためのAPIのようなもの
      - プログラマがDOMを操作すると、間接的にHTMLが書き換えられ、その結果が画面に描画される
        - 多くの動的なUIはDOM操作で成り立っている
      ```
      // <input id="email">の文字色を赤色にするDOM操作の例
      const emailInput = document.getElementById("email");
      emailInput.style.color = "red";
      ```
    - 仮想DOMはリアルDOMのプロキシのようなもので、リアルDOMと比べて、状態管理上のバグを起こしにくい設計になっている
      - パフォーマンス面では描画処理の最適化もする
    - 仮想DOMは、複雑なUIを苦労せずに実装するための仕組み
  - 宣言的UI
    - Reactを使わずにUIを実装すると、命令的なコードになり、
      - 命令的なコードでは、何かを表示したい場合でもどのように表示するかのhowの部分を細かく書く必要がある
      - 命令的なコードと宣言的なコードの違い
       ```
       下記HTMLを表示する書き方
       <ul>
          <li>リンゴ</li>
          <li>オレンジ</li>
          <li>ぶどう</li>
       </ul>
       
       命令的なコード
       const list = document.createElement("ul");
       const apple = document.createElement("li");
       apple.innerText = "リンゴ";
       list.append(apple);
       const orange = document.createElement("li");
       orange.innerText = "オレンジ";
       list.append(orange);
       const grape = document.createElement("li");
       grape.innerText = "ぶどう";
       list.append(grape);
       
       説明
       ul要素を作り、変数listに代入する
        li要素を作り、変数appleに代入する
        appleのテキストは「リンゴ」にする
        listにappleを追加する
        li要素を作り、変数orangeに代入する
        orangeのテキストは「オレンジ」にする
        listにorangeを追加する
        
       
       宣言的なコード
       function Fruits() {
          return (
            <ul>
              <li>リンゴ</li>
              <li>オレンジ</li>
              <li>ぶどう</li>
            </ul>
          );
        }
        ほぼhtmlのままどのように表示するのか書ける
        ```
  - コンポーネントベース
    - コンポーネントというのはUIの部品のこと
      - 小さいもので言えばボタンや入力欄、より大きめの部品だとフォーム、さらに大きい部品ではページもコンポーネント
    - Reactには、小さいコンポーネントを組み合わせ、大きなアプリケーションを成すという思想がある
    - メリットは、同じコンポーネントを再利用できる点
    - オープンソースのコンポーネントも数多く公開されており、カレンダーUIのような自力で作ると面倒なコンポーネントも種類豊富ある
    
## 環境の準備
- typescriptの環境作成後
- Yarnのインストール
```
npm install -g yarn

suzuki_t18752@DESKTOP-HR1248R:~/test_typescript$ npm install -g yarn
added 1 package, and audited 2 packages in 583ms
found 0 vulnerabilities
```
- プロジェクトの作成
  - npx create-react-app プロジェクト名 --template typescript
  ```
  npx create-react-app like-button --template typescript
  
  suzuki_t18752@DESKTOP-HR1248R:~$ npx create-react-app like-button --template typescript
    Need to install the following packages:
      create-react-app@5.0.1
    Ok to proceed? (y) y
    npm WARN deprecated tar@2.2.2: This version of tar is no longer supported, and will not receive security updates. Please upgrade asap.

    Creating a new React app in /home/suzuki_t18752/like-button.

    Installing packages. This might take a couple of minutes.
    Installing react, react-dom, and react-scripts with cra-template-typescript...


    added 1393 packages in 41s

    212 packages are looking for funding
      run `npm fund` for details

    Initialized a git repository.

    Installing template dependencies using npm...

    added 50 packages, and changed 1 package in 5s

    224 packages are looking for funding
      run `npm fund` for details

    We detected TypeScript in your project (src/App.test.tsx) and created a tsconfig.json file for you.

    Your tsconfig.json has been populated with default values.

    Removing template package using npm...


    removed 1 package, and audited 1443 packages in 2s

    224 packages are looking for funding
      run `npm fund` for details

    9 high severity vulnerabilities

    To address all issues (including breaking changes), run:
      npm audit fix --force

    Run `npm audit` for details.
    Git commit not created Error: Command failed: git commit -m "Initialize project using Create React App"
        at checkExecSyncError (node:child_process:861:11)
        at execSync (node:child_process:932:15)
        at tryGitCommit (/home/suzuki_t18752/like-button/node_modules/react-scripts/scripts/init.js:62:5)
        at module.exports (/home/suzuki_t18752/like-button/node_modules/react-scripts/scripts/init.js:350:25)
        at [eval]:3:14
        at Script.runInThisContext (node:vm:129:12)
        at Object.runInThisContext (node:vm:313:38)
        at node:internal/process/execution:79:19
        at [eval]-wrapper:6:22 {
      status: 128,
      signal: null,
      output: [ null, null, null ],
      pid: 6895,
      stdout: null,
      stderr: null
    }
    Removing .git directory...

    Success! Created like-button at /home/suzuki_t18752/like-button
    Inside that directory, you can run several commands:

      npm start
        Starts the development server.

      npm run build
        Bundles the app into static files for production.

      npm test
        Starts the test runner.

      npm run eject
        Removes this tool and copies build dependencies, configuration files
        and scripts into the app directory. If you do this, you can’t go back!

    We suggest that you begin by typing:

      cd like-button
      npm start

    Happy hacking!
  ```
  
- 開発サーバーの起動
  - yarn start
  
  
  
  
  
  
  
  
  
  
  
  
  
