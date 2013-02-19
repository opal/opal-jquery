require "spec_helper"

# Add our jquery extension
%x{
  $.fn.opal_specs_extension = function() {
    return "foo_bar_baz";
  };
}

describe "Element#method_missing" do
  it "calls jquery plugins by given name" do
    Element.new.opal_specs_extension.should eq("foo_bar_baz")
  end
end
