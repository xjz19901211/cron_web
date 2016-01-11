RSpec.describe Work, type: :model do
  let(:work) { create_work('aa') }

  describe 'serialize input_args' do
    it 'should save hash' do
      work.update(input_args: {a: 1, b: 2})
      expect(work.reload.input_args).to eq({'a' => 1, 'b' => 2})
    end
  end

  describe 'default value' do
    it 'input_args default eql {}' do
      expect(Work.new.input_args).to eq({})
    end
  end

  describe 'validates' do
    it 'name length should in 2..128' do
      work.name = '1'
      expect { work.name = '22' }.to change(work, :valid?).to(true)
      expect { work.name = '1' * 129 }.to change(work, :valid?).to(false)
    end

    it 'input_args length should less than 2048' do
      work.input_args = {'a': 'a' * 2040}
      expect {
        work.input_args = {'a': 'a' * 2048}
      }.to change(work, :valid?).to(false)
    end

    it 'invalid code_lang, should not save' do
      expect {
        work.code_lang = 'invalid'
      }.to change(work, :save).to(false)
    end

    it 'code length, should less than 8196' do
      work.code = 'c' * 8.kilobytes
      expect {
        work.code = 'c' * (8.kilobytes + 1)
      }.to change(work, :valid?).to(false)
    end
  end

  describe '#code=' do
    it 'should repleace \r\n to \n' do
      code = "puts hello"
      work.code = code + "\r\n"
      expect(work.code).to eq(code + "\n")
    end
  end
end
