require 'spec_helper'

RSpec.describe 'Kernel#alert' do
  it 'returns nil' do
    begin
      original_alert = `window.alert`
      message = nil
      `window.alert = function(string) { message = string; }`
      Kernel.alert('a message').should be_nil
      expect(message).to eq('a message')
    ensure
      `window.alert = #{original_alert}`
    end
  end
end
