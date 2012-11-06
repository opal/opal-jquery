describe Element do
  before do
    @div = Document.parse <<-HTML

    <table class="players">
    <tr class="player">
    <td class="name">mario</td>
    <td class="surname">rossi</td>
    </tr>
    <tr class="player">
    <td class="name">paolo</td>
    <td class="surname">bianchi</td>
    </tr>

    </table>

    HTML

    @div.append_to_body
  end

  after do
    @div.remove
  end


  describe '#each' do
    it "should change all td to pippa" do
      Document.find('table.players td').each do |el|
        el.html = "pippa"
      end

      Document.find('table.players td').first.html.should == 'pippa'
      #Document.find('table.players td').last.html.should == 'pippa'
    end
  end

  describe '#map' do
    it "should change all td.surname as array of stirng" do
      lst=Document.find('table.players td.surname').map  {|el| el.html }

      lst.should == ['rossi','bianchi']
    end
  end

  describe "#to_a" do
    it "should return a list of class Array" do
      Document.find('table.players td.surname').to_a.class.should == Array
    end
    
    it "should check first and last element" do
      Document.find('table.players td.surname').to_a.first.html == "rossi"
      Document.find('table.players td.surname').to_a.last.html == "bianchi"
    end
    
    it "should get only element with class surname" do
      Document.find('table.players td').to_a.select {|el| el.has_class?('surname') }.
      map {|el| el.class }.uniq  == ['surname']
    end
    
  end

end
