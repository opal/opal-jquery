require "spec_helper"

RSpec.describe HTTP do
  let(:good_url) { '/spec/fixtures/simple.txt' }
  let(:json_url) { '/spec/fixtures/user.json' }
  let(:bad_url) { '/spec/fixtures/does_not_exist.txt' }

  describe ".setup" do
    it 'presents the $.ajaxSetup() object as a Hash' do
      expect(HTTP.setup).to be_a Hash
    end
  end

  describe ".get" do
    describe "with a block" do
      it "returns the http object instance" do
        expect(HTTP.get(good_url) {}).to be_a HTTP
      end

      async "block gets called on success" do
        HTTP.get(good_url) do |response|
          async { expect(response).to be_ok }
        end
      end

      async "block gets called on failure" do
        HTTP.get(bad_url) do |response|
          async { expect(response).to_not be_ok }
        end
      end
    end

    describe "without a block" do
      it "returns a promise" do
        expect(HTTP.get(good_url)).to be_a Promise
      end

      async "returns a promise which accepts a then-block for successful response" do
        HTTP.get(good_url).then do |response|
          async { expect(response).to be_ok }
        end
      end

      async "returns a promise which accepts a fail-block for failing response" do
        HTTP.get(bad_url).fail do |response|
          async { expect(response).to_not be_ok }
        end
      end
    end
  end

  describe '#body' do
    async 'returns the response body as a string' do
      HTTP.get(good_url) do |response|
        async { expect(response.body).to eq('hey') }
      end
    end
  end

  describe '#json' do
    async 'returns the json converted into native ruby objects' do
      HTTP.get(json_url) do |response|
        async { expect(response.json).to eq({ 'name' => 'Adam', 'age' => 26 }) }
      end
    end
  end

  describe '#ok?' do
    async 'returns true when the request was a sucess' do
      HTTP.get(good_url) do |response|
        async { expect(response).to be_ok }
      end
    end

    async 'returns false when the request failed' do
      HTTP.get(bad_url) do |response|
        async { expect(response).to_not be_ok }
      end
    end
  end

  describe '#get_header' do
    async 'returns the header value' do
      HTTP.get(good_url) do |response|
        async { expect(response.get_header 'Content-Type').to eq 'text/plain' }
      end
    end

    async 'returns nil' do
      HTTP.get(good_url) do |response|
        async { expect(response.get_header 'Does-Not-Exist').to be nil }
      end
    end
  end
end
