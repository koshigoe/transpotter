require_relative '../spec_helper'

RSpec.describe 'api role', type: :serverspec do
  it_behaves_like 'Git'
  it_behaves_like 'Ruby'
  it_behaves_like 'network-scripts'
  it_behaves_like 'resolv' do
    describe file '/etc/resolv.conf' do
      its(:content) { should match '^nameserver 192.168.33.53$' }
    end
  end
end
