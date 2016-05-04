require_relative '../spec_helper'

RSpec.describe 'db role', type: :serverspec do
  it_behaves_like 'PostgreSQL'
  it_behaves_like 'resolv' do
    describe file '/etc/resolv.conf' do
      its(:content) { should match '^nameserver 192.168.33.53$' }
    end
  end
end
