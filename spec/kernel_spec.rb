require 'spec_helper'

RSpec.describe 'Kernel#alert', type: :feature do
  it 'returns nil' do
    visit '/'
    binding.irb
    save_and_open_page
    # begin
    #   original_alert = `window.alert`
    #   message = nil
    #   `window.alert = function(string) { message = string; }`
    #   Kernel.alert('a message').should be_nil
    #   expect(message).to eq('a message')
    # ensure
    #   `window.alert = #{original_alert}`
    # end
  end
end
