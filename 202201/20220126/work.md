### 使いづらい実装
```
例
- 通知をする為のモジュールだけどユーザーの通知のみにしか使えなくなっている
module noification
  include User
end

↓
- 外側、使う場所で切り替えを行おう
module noification
end

class UserNotification
  include noification
end
```

### [rails before_action](https://railsdoc.com/page/before_action)
- アクションの前に実行したいメソッドを設定する
```
例
- newが実行される前にrequire_permissionが実行される

before_action :require_permission, only: [:new]
def require_permission
  unless current_user.partner? || current_user.admin?
    redirect_to admin_root_path, alert: 'ここから先は管理者限定です！'
  end
end

def new
 p 'test'
end
```
