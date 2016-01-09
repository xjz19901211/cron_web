require 'rails_helper'

RSpec.describe "tasks/new", type: :view do
  before(:each) do
    assign(:task, Task.new(
      :work_id => 1,
      :output => "MyText"
    ))
  end

  it "renders new task form" do
    render

    assert_select "form[action=?][method=?]", tasks_path, "post" do

      assert_select "input#task_work_id[name=?]", "task[work_id]"

      assert_select "textarea#task_output[name=?]", "task[output]"
    end
  end
end