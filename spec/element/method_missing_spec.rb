require "spec_helper"

RSpec.describe "Element#method_missing" do
  context 'with missing property' do
    html %{<div id="foo" class="bar"></div>}

    it 'fallsback on method_missing when a method is unknown' do
      expect(Element['#foo'].offsetParent).to eq(Element['body'])
    end
  end

  context 'jQuery plugin methods' do
    subject(:element) { Element.new }

    before do
      `$.fn.pluginMethod = function() {return 123}`
    end

    after do
      `delete $.fn.pluginMethod; delete $.fn.$pluginMethod;`
    end

    it 'calls method_missing' do
      expect(element).to receive(:method_missing).once.with(:pluginMethod)
      element.pluginMethod
    end

    it 'calls forwards to the plugin', :focus do
      pending "broken on opal < 0.11" if RUBY_ENGINE_VERSION.to_f < 0.11
      expect(element.pluginMethod).to eq(123)
    end
  end
end
