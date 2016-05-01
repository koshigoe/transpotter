shared_examples_for 'Ruby' do
  describe package 'ruby' do
    it { should be_installed.with_version '2.3.1' }
  end

  describe package 'bundler' do
    it { should be_installed.by 'gem' }
  end
end
