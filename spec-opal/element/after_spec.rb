require 'spec_helper'

RSpec.describe 'Element#after' do
  html <<-HTML
    <div id="some-header" class="kapow"></div>
    <div id="foo" class="after-spec-first"></div>
    <div id="bar" class="after-spec-first"></div>
    <div id="baz"></div>
  HTML

  it 'should insert the given html string after each element' do
    el = find '.after-spec-first'
    expect(el.size).to eq(2)

    el.after '<p class="woosh"></p>'

    expect(find('#foo').next.class_name).to eq('woosh')
    expect(find('#bar').next.class_name).to eq('woosh')
  end

  it 'should insert the given DOM element after this element' do
    find('#baz').after find('#some-header')
    expect(find('#baz').next.id).to eq('some-header')
  end
end
