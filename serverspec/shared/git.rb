shared_examples_for 'Git' do
  describe package 'git' do
    it { should be_installed }
  end
end
