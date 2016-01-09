require 'rails_helper'

RSpec.describe "works/edit", type: :view do
  before(:each) do
    @work = assign(:work, Work.create!(
      :name => "MyString",
      :input_args => "MyText",
      :code_lang => "MyString",
      :code => "MyText"
    ))
  end

  it "renders the edit work form" do
    render

    assert_select "form[action=?][method=?]", work_path(@work), "post" do

      assert_select "input#work_name[name=?]", "work[name]"

      assert_select "textarea#work_input_args[name=?]", "work[input_args]"

      assert_select "input#work_code_lang[name=?]", "work[code_lang]"

      assert_select "textarea#work_code[name=?]", "work[code]"
    end
  end
end
