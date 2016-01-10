require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { create_task('t') }

  describe 'default value' do
    it 'status eql pending' do
      expect(Task.new.status).to eq('pending')
      task.update(status: 'running')
      expect(task.reload.status).to eq('running')
    end
  end

  describe 'run_code' do
    let(:work) { task.work }

    before :each do
      work.update(input_args: {a: 1, b: "what's up?"})
    end

    describe 'ruby lang' do
      before :each do
        work.update(code_lang: 'ruby', code: 'puts 1')
      end

      it 'should convernt input_args to ruby code' do
        expect(task.run_code).to eq(%Q{INPUT_ARGS = {"a"=>1, "b"=>"what's up?"}\nputs 1})
      end
    end

    describe 'shell lang' do
      before :each do
        work.update(code_lang: 'shell', code: 'echo 1')
      end

      it 'should convernt input_args to ruby code' do
        expect(task.run_code).to eq(%Q{a=1\nb=what\\'s\\ up\\?\necho 1})
      end
    end

    describe 'javascript lang' do
      before :each do
        work.update(code_lang: 'javascript', code: 'Logger.info(1)')
      end

      it 'should convernt input_args to ruby code' do
        expect(task.run_code).to eq(
          %Q{INPUT_ARGS = {"a":1,"b":"what's up?"}\nLogger.info(1)}
        )
      end
    end
  end
end
