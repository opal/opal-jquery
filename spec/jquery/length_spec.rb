describe "JQuery#length" do
  it "should report the number of elements in the instance" do
    JQuery.new.length.should == 1
  end
end