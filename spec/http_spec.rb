require "spec_helper"

describe HTTP do
  describe ".get" do
    context "with a block" do
      it "returns the http object instance" do
        HTTP.get('/spec/fixtures/simple.txt') do
        end.should be_a HTTP
      end

      async "block gets called on success" do
        HTTP.get('spec/fixtures/simple.txt') do |response|
          run_async { response.should be_ok }
        end
      end

      async "block gets called on failure" do
        HTTP.get('/spec/does/not/exist.txt') do |response|
          run_async { response.should_not be_ok }
        end
      end
    end

    context "without a block" do
      it "returns a promise" do
        HTTP.get('/spec/fixtures/simple.txt').should be_a Promise
      end

      async "returns a promise which accepts a then-block for successful response" do
        HTTP.get('spec/fixtures/simple.txt').then do |response|
          run_async { response.should be_ok }
        end
      end

      async "returns a promise which accepts a fail-block for failing response" do
        HTTP.get('spec/does/not/exist.txt').fail do |response|
          run_async { response.should_not be_ok }
        end
      end
    end
  end

  describe '#body' do
    async 'returns the response body as a string' do
      HTTP.get('spec/fixtures/simple.txt') do |response|
        run_async { response.body.should == "hey" }
      end
    end
  end

  describe '#json' do
    async 'returns the json converted into native ruby objects' do
      HTTP.get('spec/fixtures/user.json') do |response|
        run_async { response.json.should == { 'name' => 'Adam', 'age' => 26 } }
      end
    end
  end

  describe '#ok?' do
    async 'returns true when the request was a sucess' do
      HTTP.get('spec/fixtures/simple.txt') do |response|
        run_async { response.should be_ok }
      end
    end

    async 'returns false when the request failed' do
      HTTP.get('spec/fixtures/non_existant.txt') do |response|
        run_async { response.should_not be_ok }
      end
    end
  end
end
