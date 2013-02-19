require "spec_helper"

describe "Element animation methods" do
  html <<-HTML
    <div id="animate-foo"></div>
  HTML

  describe "#animate" do
    ### HACKY
    # jQUery's animate method doesn't *always* finish on time
    # so the values are being compared using greater than
    
    it "should animate a set of properties and values" do
      foo = Element.find "#animate-foo"
      foo.animate :width => "200px"

      set_timeout 400 do
        (foo.css("width").to_f > 199).should be_true
      end
    end

    it "should allow you to set a speed in the params" do
      foo = Element.find "#animate-foo"
      foo.animate :width => "200px", :speed => 100

      set_timeout 105 do
        (foo.css("width").to_f > 199).should be_true
      end
    end

    it "should accept a block as a callback" do
      foo = Element.find "#animate-foo"
      foo.animate :width => "200px" do
        foo.add_class "finished"
      end

      set_timeout 405 do
        foo.class_name.should equal("finished")
      end
    end
  end
end
