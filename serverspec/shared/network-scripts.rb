shared_examples_for 'network-scripts' do
  describe file '/etc/sysconfig/network-scripts/ifcfg-enp0s3' do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should include 'PEERDNS=no' }
  end
end
