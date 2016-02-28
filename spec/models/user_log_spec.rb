require 'rails_helper'

RSpec.describe UserLog, type: :model do
  let(:user_log) { create_user_log('a') }

  describe 'misc' do
    it 'should serialize params' do
      user_log.update(params: {'a' => 1})
      expect(user_log.reload.params).to eq('a' => 1)
    end
  end
end
