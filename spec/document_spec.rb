require "spec_helper"

describe Document do
  describe '.title and .title=' do
    it 'sets/gets the page title' do
      current = Document.title
      Document.title = 'hello from opal'
      Document.title.should == 'hello from opal'
      Document.title = current
    end
  end
end
