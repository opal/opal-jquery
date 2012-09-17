describe Element do
  before do
    @div = Document.parse <<-HTML
      <div id="attributes-spec">
        <div id="foo"></div>
        <div id="bar" class="apples"></div>
        <div id="baz" class="lemons"></div>
      </div>
    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end

  describe '#toggle_class' do
    it 'adds the given class name to the element if not already present' do
      foo = Document['#foo']
      foo.has_class?('oranges').should be_false
      foo.toggle_class 'oranges'
      foo.has_class?('oranges').should be_true
    end

    it 'removes the class if the element already has it' do
      bar = Document['#bar']
      bar.has_class?('apples').should be_true
      bar.toggle_class 'apples'
      bar.has_class?('apples').should be_false
    end
  end
end