require 'spec_helper'

describe 'Element#prepend' do
  html <<-HTML
    <div id="foo"></div>
    <div id="bar">
      <p>Something</p>
    </div>
  HTML

  it 'inserts the given html to beginning of element' do
    foo = Element.find '#foo'
    bar = Element.find '#bar'

    foo.prepend '<span>Bore Da</span>'
    expect(foo.children.first.text).to eq 'Bore Da'

    bar.prepend '<span>Charlie</span>'
    expect(bar.children.first.text).to eq 'Charlie'
  end
end
