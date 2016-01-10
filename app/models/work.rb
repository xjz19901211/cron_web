class Work < ActiveRecord::Base
  CODE_LANGS = %w{ruby shell javascript}

  serialize :input_args, JSON

  validates :name, presence: true, length: {in: 2..128}
  validates :input_args_json, length: {maximum: 2.kilobytes}
  validates :code_lang, inclusion: {in: CODE_LANGS}
  validates :code, length: { maximum: 8.kilobytes }


  has_many :tasks

  def initialize(attrs = {})
    super(attrs)
    self.input_args ||= {}
  end

  def input_args_json
    input_args.to_json
  end

  def code=(text)
    clean_text = text.lines.map {|l| l.gsub("\r\n", "\n") }.join
    super(clean_text)
  end

  def run
    tasks.create!.tap do |task|
      CodeWorker.new(task).perform
    end
  end
end
