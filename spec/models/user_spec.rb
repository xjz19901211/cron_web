require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create_user('a') }

  describe 'default value' do
    it 'role default eql normal' do
      expect(User.new.role).to eq('normal')
    end
  end

  describe 'validates' do
    it 'should use valid email' do
      expect { user.email = 'asdf' }.to change(user, :valid?).to(false)
      expect { user.email = 'as.as@adf.com' }.to change(user, :valid?).to(true)
    end

    it 'should use better password, length >= 8' do
      expect { user.password = '1234567' }.to change(user, :valid?).to(false)
      expect { user.password = '12345678' }.to change(user, :valid?).to(true)
      u = User.find(user.id)
      expect(u.valid?).to eq(true)
    end

    it 'should use correct roles' do
      expect { user.role = 'asdf' }.to change(user, :valid?).to(false)
      expect { user.role = 'admin' }.to change(user, :valid?).to(true)
    end
  end

  describe 'password' do
    it 'should save password_hash' do
      expect(user.password_hash).to_not be_nil
      expect(user.password_hash).to_not eq('password')
      expect(user.password).to eq('password')
    end
  end
end
