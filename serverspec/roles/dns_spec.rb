require_relative '../spec_helper'

RSpec.describe 'dns role', type: :serverspec do
  it_behaves_like 'dnsmasq'
end
