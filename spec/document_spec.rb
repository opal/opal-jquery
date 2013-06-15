require 'spec_helper'

describe "Document.ready?" do
  it "accepts a block" do
    $document.ready? { }
  end
end
