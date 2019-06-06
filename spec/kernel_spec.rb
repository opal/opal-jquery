require 'spec_helper'

RSpec.describe 'Kernel#alert', type: :feature do
  it 'returns nil' do
    accept_alert do
      expect(evaluate_opal(%{alert "message 1"})).to eq(opal_nil)
    end
  end

  it 'shows an alert' do
    accept_alert("message 1") { execute_opal %{alert "message 1"} }
    accept_alert("message 2") { execute_opal %{Kernel.alert "message 2"} }
  end
end
