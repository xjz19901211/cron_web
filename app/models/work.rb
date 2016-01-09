class Work < ActiveRecord::Base
  CODE_LANGS = %w{javascript ruby shell}

  serialize :input_args, JSON

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

  def run
    tasks.create!(output: "Start...\n").tap do |task|
      task.with_lock do
        task.output += "completed.\n"
        task.save
      end
    end
  end
end
