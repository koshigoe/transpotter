shared_examples_for 'dnsmasq' do
  describe package 'dnsmasq' do
    it { should be_installed }
  end

  describe service 'dnsmasq' do
    it { should be_enabled }
    it { should be_running }
  end

  describe file '/etc/dnsmasq.d/address.conf' do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match '^address=/vm/127.0.0.1$' }
  end

  describe file '/etc/nsswitch.conf' do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match '^hosts:\s+dns files$' }
  end
end
