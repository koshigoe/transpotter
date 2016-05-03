shared_examples_for 'ProFTPD' do
  describe package 'proftpd' do
    it { should be_installed }
  end

  describe package 'proftpd-postgresql' do
    it { should be_installed }
  end

  describe service 'proftpd' do
    it { should be_enabled }
    it { should be_running }
  end

  describe file '/etc/proftpd.conf' do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 640 }
    its(:content) { should match '^\s*ServerName\s+"Transpotter"' }
    its(:content) { should match '^\s*ServerAdmin\s+root@localhost' }
    its(:content) { should match '^\s*HiddenStores\s+on' }
    its(:content) { should match '^\s*DeleteAbortedStores\s+on' }
    its(:content) { should match '^\s*AllowOverwrite\s+no' }
  end
end
