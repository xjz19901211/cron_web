class Task < ActiveRecord::Base
  ALL_STATUS = %w{pending running finished failed}

  validates :status, inclusion: {in: ALL_STATUS}

  belongs_to :user
  belongs_to :work
  belongs_to :schedule


  def initialize(attrs = {})
    super(attrs)
    self.status ||= 'pending'
  end

  def run_code
    input_args = send("#{work.code_lang}_input_args")

    "#{input_args}\n#{work.code}"
  end


  private

  def ruby_input_args
    "INPUT_ARGS = #{work.input_args.to_s}"
  end

  def javascript_input_args
    "INPUT_ARGS = #{work.input_args.to_json}"
  end

  def shell_input_args
    work.input_args.map do |key, val|
      "#{key}=#{Shellwords.escape(val)}"
    end.join("\n")
  end
end
