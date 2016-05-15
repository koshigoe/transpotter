require_relative '../spec_helper'

RSpec.describe 'dns role', type: :serverspec do
  it_behaves_like 'dnsmasq'
  it_behaves_like 'network-scripts'
  it_behaves_like 'resolv' do
    describe file '/etc/resolv.conf' do
      its(:content) { should match '^nameserver 127.0.0.1$' }
    end
  end
end
