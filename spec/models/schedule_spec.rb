RSpec.describe Schedule, type: :model do
  let(:schedule) { create_schedule('aa') }

  describe 'default value' do
    it 'active default eql true' do
      expect(Schedule.new.active).to eq(true)
    end
  end

  describe 'validates' do
    it 'name length should in 2..128' do
      schedule.name = '1'
      expect { schedule.name = '22' }.to change(schedule, :valid?).to(true)
      expect { schedule.name = '1' * 129 }.to change(schedule, :valid?).to(false)
    end
  end
end
