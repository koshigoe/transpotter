shared_examples_for 'Ruby' do
  describe package 'ruby' do
    it { should be_installed.with_version '2.3.1' }
  end

  describe package 'bundler' do
    it { should be_installed.by 'gem' }
  end

  describe package 'gcc' do
    it { should be_installed }
  end

  describe package 'postgresql95-devel' do
    it { should be_installed }
  end

  describe package 'libxml2-devel' do
    it { should be_installed }
  end

  describe package 'libxslt-devel' do
    it { should be_installed }
  end
end
