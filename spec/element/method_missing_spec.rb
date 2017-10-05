require "spec_helper"

RSpec.describe "Element#method_missing" do
  context 'with missing property' do
    html %{<div id="foo" class="bar"></div>}

    it 'fallsback on method_missing when a method is unknown' do
      expect(Element['#foo'].offsetParent).to eq(Element['body'])
    end
  end
end
