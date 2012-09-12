describe HTTP do
  describe '#body' do
    async 'returns the response body as a string' do
      HTTP.get('data/simple.txt') do |response|
        run_async { response.body.should == "hey" }
      end
    end
  end

  describe '#ok?' do
    async 'returns true when the request was a sucess' do
      HTTP.get('data/simple.txt') do |response|
        run_async { response.ok?.should be_true }
      end
    end

    async 'returns false when the request failed' do
      HTTP.get('data/non_existant.txt') do |response|
        run_async { response.ok?.should be_true }
      end
    end
  end
end