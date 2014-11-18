require "spec_helper"

describe "Element animation methods" do
  html <<-HTML
    <div id="animate-foo"></div>
  HTML

  describe "#animate" do
    ### HACKY
    # jQUery's animate method doesn't *always* finish on time
    # so the values are being compared using greater than

    async "should animate a set of properties and values" do
      foo = Element.find "#animate-foo"
      foo.animate :width => "200px"

      delay 0.4 do
        async { (foo.css("width").to_f > 199).should eq(true) }
      end
    end

    async "should allow you to set a speed in the params" do
      foo = Element.find "#animate-foo"
      foo.animate :width => "200px", :speed => 100

      delay 0.150 do
        async { (foo.css("width").to_f > 199).should eq(true) }
      end
    end

    async "should accept a block as a callback" do
      foo = Element.find "#animate-foo"
      foo.animate :width => "200px", :speed => 100 do
        foo.add_class "finished"
      end

      delay 0.405 do
        async { foo.class_name.should eq("finished") }
      end
    end
  end
end

describe "Element effects methods" do
  html <<-HTML
    <div id="effects-foo"></div>
  HTML
  
  describe "#fadeout / #fadein" do
    async "should fade the element out first" do
      foo = Element.find "#effects-foo"
      foo.effect(:fade_out)
      
      delay 1 do
        async {
          foo.css("display").should eq("none")
          foo.effect(:fade_in)
        }
      end
    end
    async "should fade the element back in" do
      delay 2 do
        async { Element["#effects-foo"].css("display").should eq("block") }
      end
    end
  end
end