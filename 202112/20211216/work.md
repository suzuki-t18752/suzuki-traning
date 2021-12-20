## ruby
- is_a?()
  - 指定したクラスかどうか確認する


### カスタムシリアライザー
- Active_jobではjobにエンキューする前に与えられた引数をシリアライズする
- HashやArray,String等の基本的なクラス、Active_record_relations等元々railsに設定されているクラスなら特に何もせずシリアライズが可能
- しかし自作したクラスはシリアライズが出来ないので下記のようなカスタムシリアライザーを導入する
- serializeの際にクラスを再インスタンス化する為に必要な引数をハッシュにする
- deserialize後にハッシュ化した引数を元に再インスタンス化を行うことでクラスを再度扱えるようにしている
```
#lib/serializers/auth_result_serializer.rb

class AuthResultSerializer < ActiveJob::Serializers::ObjectSerializer

  # ある引数がこのシリアライザでシリアライズされるべきかどうかをチェックする
  def serialize?(argument)
    argument.is_a? Values::AuthResult
  end

  # あるオブジェクトを、オブジェクト型をサポートするもっとシンプルな表現形式に変換する。
  # 表現形式としては特定のキーを持つハッシュが推奨される。キーには基本型のみが利用可能。
  # `super`を読んでカスタムシリアライザ型をハッシュに追加すべき
  def serialize(auth_result)
    error_hash = {
      error_class: auth_result.error.class,
      error_message: auth_result.error.message,
    }
    super(
      auth_result.to_h.merge(error_hash)
    )
  end

  # シリアライズされた値を正しいオブジェクトに逆変換する
  def deserialize(hash)
    hash['error'] = hash['error_class'].new(hash['error_message'])
    Values::AuthResult.new(hash)
  end
end
```
```
#シリアライザーの読込
#config/initializers/custom_serializers.rb

# frozen_string_literal: true
Rails.application.reloader.to_prepare do
  Rails.application.config.active_job.custom_serializers << Serializers::AuthResultSerializer
end

```
```
#テスト
spec/lib/serializers/auth_result_serializer_spec.rb

# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Serializers::AuthResultSerializer, type: :serializers do
  let!(:name) { create(:name) }
  let(:auth_result) do
    build(:SC_values_auth_result, name_id: name.id)
  end
  let(:auth_result_hash) do
    {
      '_aj_serialized' => 'Serializers::AuthResultSerializer',
      :succeeded => false,
      :password_will_expire => false,
      :remain_days => nil,
      :remain_days_text => nil,
      :password_expired => false,
      :error => auth_result.error,
      :name_id => name.id,
      :id => nil,
      :error_class => Errors::Auth::LedgerAuthError,
      :error_message => 'Errors::Auth::LedgerAuthError',
    }
  end
  let(:hash_serialized) do
    {
      '_aj_serialized' => 'Serializers::AuthResultSerializer',
      'succeeded' => false,
      'password_will_expire' => false,
      'remain_days' => nil,
      'remain_days_text' => nil,
      'password_expired' => false,
      'error' => auth_result.error.to_s,
      'name_id' => name.id,
      'id' => nil,
      'error_class' => 'Errors::Auth::LedgerAuthError',
      'error_message' => 'Errors::Auth::LedgerAuthError',
    }
  end

  describe '#serialize?' do
    context 'when auth_result' do
      it { expect(described_class.serialize?(auth_result)).to eq true }
    end
    context 'when other than auth_result' do
      it { expect(described_class.serialize?(name)).to eq false }
    end
  end

  describe '#serialize' do
    it do
      expect(described_class.serialize(auth_result).class).to eq Hash
      expect(described_class.serialize(auth_result)).to match(auth_result_hash)
    end
  end

  describe '#deserialize' do
    it 'check class' do
      expect(described_class.deserialize(hash_serialized).class).to eq Values::AuthResult
      expect(described_class.deserialize(hash_serialized).error.class).to eq Errors::Auth::LedgerAuthError
    end
    it 'check object' do
      expect(described_class.deserialize(hash_serialized).attributes.inspect).to eq Values::AuthResult.new(
        succeeded: false,
        password_will_expire: false,
        remain_days: nil,
        remain_days_text: nil,
        password_expired: false,
        error: auth_result.error,
        name_id: name.id,
        id: nil,
      ).attributes.inspect
    end
  end
end

クラスの中身を検証するのにattributesを使う
このままだとエラーが発生するのでinspectで全体を文字列に変換して比べるようにする
```
