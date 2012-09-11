describe JQuery do
  describe '#on' do
    before do
      @div = Document.parse <<-HTML
        <div id="on-spec">
          <div id="foo">
            <div id="bar" class="apples"></div>
          </div>
          <div id="baz"></div>
        </div>
      HTML

      @div.append_to_body
    end

    after do
      @div.remove
    end

    it 'adds an event listener onto the jquery element' do
      count = 0
      foo   = Document['#foo']

      foo.on(:click) { count += 1 }
      count.should == 0
      foo.trigger(:click)
      count.should == 1
      foo.trigger(:click)
      count.should == 2
      foo.trigger(:mousedown)
      count.should == 2
    end

    it 'takes an optional second parameter to delegate events' do
      count = 0
      foo   = Document['#foo']
      bar   = Document['#bar']

      foo.on(:click, '#bar') { count += 1 }
      count.should == 0
      foo.trigger(:click)
      count.should == 0
      bar.trigger(:click)
      count.should == 1
      bar.trigger(:click)
      count.should == 2
      bar.trigger(:mousedown)
      count.should == 2
    end

    it 'can listen for non-browser events' do
      count = 0
      foo   = Document['#foo']

      foo.on('opal-is-mega-lolz') { count += 1 }
      count.should == 0
      foo.trigger('opal-is-mega-lolz')
      count.should == 1
      foo.trigger('opal-is-mega-lolz')
      count.should == 2
    end
  end
end