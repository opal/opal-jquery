require "spec_helper"

describe HTTP do
  describe '#body' do
    async 'returns the response body as a string' do
      HTTP.get('spec/fixtures/simple.txt') do |response|
        run_async { response.body.should == "hey" }
      end
    end
  end

  describe '#callback' do
    async 'can add a success callback after the request is sent' do
      http = HTTP.get('spec/fixtures/simple.txt')
      http.callback do |response|
        run_async { response.ok?.should be_true }
      end
    end
  end

  describe '#callback' do
    async 'can add a failure callback after the request is sent' do
      http = HTTP.get('spec/fixtures/bad_url.txt')
      http.errback do |response|
        run_async { response.ok?.should be_false }
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
        run_async { response.ok?.should be_true }
      end
    end

    async 'returns false when the request failed' do
      HTTP.get('spec/fixtures/non_existant.txt') do |response|
        run_async { response.ok?.should be_false }
      end
    end
  end
end
