shared_examples_for 'nginx' do
  describe package 'nginx' do
    it { should be_installed }
  end

  describe service 'nginx' do
    it { should be_enabled }
    it { should be_running }
  end

  describe file '/etc/nginx/conf.d/default.conf' do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end
end
