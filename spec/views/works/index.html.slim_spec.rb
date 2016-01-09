require 'rails_helper'

RSpec.describe "works/index", type: :view do
  before(:each) do
    assign(:works, [
      Work.create!(
        :name => "Name",
        :input_args => "MyText",
        :code_lang => "Code Lang",
        :code => "MyText"
      ),
      Work.create!(
        :name => "Name",
        :input_args => "MyText",
        :code_lang => "Code Lang",
        :code => "MyText"
      )
    ])
  end

  it "renders a list of works" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Code Lang".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
