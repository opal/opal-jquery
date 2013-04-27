require "spec_helper"

describe $document do
  describe '.title and .title=' do
    it 'sets/gets the page title' do
      current = $document.title
      $document.title = 'hello from opal'
      $document.title.should == 'hello from opal'
      $document.title = current
    end
  end
end
