require 'rails_helper'

RSpec.describe "works/new", type: :view do
  before(:each) do
    assign(:work, Work.new(
      :name => "MyString",
      :input_args => "MyText",
      :code_lang => "MyString",
      :code => "MyText"
    ))
  end

  it "renders new work form" do
    render

    assert_select "form[action=?][method=?]", works_path, "post" do

      assert_select "input#work_name[name=?]", "work[name]"

      assert_select "textarea#work_input_args[name=?]", "work[input_args]"

      assert_select "input#work_code_lang[name=?]", "work[code_lang]"

      assert_select "textarea#work_code[name=?]", "work[code]"
    end
  end
end
