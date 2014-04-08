require "spec_helper"

describe "Element height and width" do
  html <<-HTML
    <div id="dimensions" style='width: 100px; height: 200px'></div>
  HTML

  describe '#height' do
    it "should grab height of existing element" do
      elm = Element.id('dimensions')

      expect(elm.height).to eq(200)
    end

    it "should return nil if item does not exist" do
      elm = Element.find('#not-an-elm')

      expect(elm.height).to eq(nil)
    end
  end

  describe '#height=' do
    it "should allow us to set height" do
      elm = Element.id('dimensions')
      elm.height = 121

      expect(elm.height).to eq(121)
    end
  end

  describe '#width' do
    it "should grab width of existing element" do
      elm = Element.id('dimensions')

      expect(elm.width).to eq(100)
    end

    it "should return nil if item does not exist" do
      elm = Element.find('#not-an-elm')

      expect(elm.width).to eq(nil)
    end
  end

  describe '#width=' do
    it "should allow us to set width" do
      elm = Element.id('dimensions')
      elm.width = 121

      expect(elm.width).to eq(121)
    end
  end
end
