require 'spec_helper'
require 'opal/jquery/local_storage'

RSpec.describe LocalStorage do
  before { subject.clear }

  it "returns nil for undefined values" do
    expect(subject['foo']).to be_nil
  end

  it "should be able to create items" do
    subject['foo'] = 'Ford Prefect'
    expect(subject['foo']).to eq('Ford Prefect')
  end

  it "should be able to delete items" do
    subject['name'] = 'Arthur'
    subject.delete 'name'

    expect(subject['name']).to be_nil
  end
end
