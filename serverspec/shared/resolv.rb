shared_examples_for 'resolv' do
  describe file '/etc/resolv.conf' do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match '^nameserver 10.0.2.3$' }
  end
end
