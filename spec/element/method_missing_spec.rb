require "spec_helper"

# Add our jquery extension
%x{
  $.fn.opal_specs_extension = function() {
    return "foo_bar_baz";
  };

  $.fn.opal_specs_args = function() {
    return Array.prototype.slice.call(arguments);
  };
}

class Element
  expose :opal_specs_extension, :opal_specs_args
end

describe "Element#exposes" do
  it "exposes jquery plugins by given name" do
    Element.new.opal_specs_extension.should eq("foo_bar_baz")
  end

  it "forwards any args onto native function" do
    Element.new.opal_specs_args(:foo, 42, false).should eq([:foo, 42, false])
  end

  it "only forwards calls when a native method exists" do
    expect {
      Element.new.some_unknown_plugin
    }.to raise_error(Exception)
  end
end
