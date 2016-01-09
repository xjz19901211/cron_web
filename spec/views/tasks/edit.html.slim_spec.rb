require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
  before(:each) do
    @task = assign(:task, Task.create!(
      :work_id => 1,
      :output => "MyText"
    ))
  end

  it "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", task_path(@task), "post" do

      assert_select "input#task_work_id[name=?]", "task[work_id]"

      assert_select "textarea#task_output[name=?]", "task[output]"
    end
  end
end
