require 'rails_helper'

RSpec.describe "works/show", type: :view do
  before(:each) do
    @work = assign(:work, Work.create!(
      :name => "Name",
      :input_args => "MyText",
      :code_lang => "Code Lang",
      :code => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Code Lang/)
    expect(rendered).to match(/MyText/)
  end
end
