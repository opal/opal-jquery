require "spec_helper"

RSpec.describe "Element#expose" do
  subject(:element) { Element.new }
  before do
    `$.fn.exposableMethod = function() {return 123}`
    `$.fn.exposableMethod2 = function() {return 12}`
    `$.fn.opal_specs_extension = function() {return "foo_bar_baz";};`
    `$.fn.opal_specs_args = function() {return Array.prototype.slice.call(arguments);};`
    Element.expose :opal_specs_extension, :opal_specs_args
  end

  after do
    `delete $.fn.exposableMethod; delete $.fn.$exposableMethod;`
    `delete $.fn.exposableMethod2; delete $.fn.$exposableMethod2;`
    `delete $.fn.opal_specs_extension; delete $.fn.$opal_specs_extension;`
    `delete $.fn.opal_specs_args; delete $.fn.$opal_specs_args;`
  end

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

  it 'exposes methods defined on $.fn' do
    expect(element).to respond_to(:exposableMethod) # via #respond_to_missing?
    expect(element.methods).not_to include(:exposableMethod)
    Element.expose :exposableMethod
    expect(element.methods).to include(:exposableMethod)
    expect(element).to respond_to(:exposableMethod) # via method missing
    expect(element.exposableMethod).to eq(123)
  end

  it 'work if exposing the same method multiple times' do
    Element.expose :exposableMethod
    Element.expose :exposableMethod
    expect(element.exposableMethod).to eq(123)

    Element.expose :exposableMethod, :exposableMethod
    expect(element.exposableMethod).to eq(123)
  end

  it 'work if exposing multiple methods' do
    Element.expose :exposableMethod, :exposableMethod2
    expect(element.exposableMethod).to eq(123)
    expect(element.exposableMethod2).to eq(12)
  end

  it 'does not call method_missing after the method is exposed' do
    pending "broken on opal < 0.11" if RUBY_ENGINE_VERSION.to_f < 0.11

    expect(element).to receive(:method_missing).once.with(:exposableMethod)
    def element.method_missing(name)
      "#{name} (via method_missing)"
    end

    expect(element.exposableMethod).to eq("exposableMethod (via method_missing)")
    Element.expose :exposableMethod

    expect(element).not_to receive(:method_missing).once
    element.exposableMethod
  end

end
