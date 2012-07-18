describe "DOM#length" do
  it "should report the number of elements in the instance" do
    DOM.new.length.should == 1
  end
end