shared_examples_for 'ProFTPDAccount' do
  describe 'validation' do
    subject { build(described_class.table_name.singularize) }

    describe 'password' do
      context 'on create' do
        it { is_expected.to validate_presence_of(:password) }
      end

      context 'on update' do
        subject { create(described_class.table_name.singularize) }
        it { is_expected.to allow_value('').for(:password) }
      end
    end
  end

  describe '#before_create' do
    subject do
      described_class.create!(
        password: 'password',
        uid: Rails.configuration.x.proftpd_account.default_uid,
        gid: Rails.configuration.x.proftpd_account.default_gid,
        homedir: Rails.configuration.x.proftpd_account.default_homedir,
      )
    end

    it 'is set hashed password to password_digest' do
      expect(subject.password_digest).to match /\A\{sha256\}[a-zA-Z0-9\+\/=]+\z/
    end
  end

  describe '#after_create' do
    subject do
      described_class.create!(
        password: 'password',
        uid: 1000,
        gid: 1000,
        homedir: '/home/vagrant',
      )
    end

    it 'set username' do
      expect(subject.reload.username).to eq "#{described_class.name.underscore.split('_').first}-#{subject.id}"
    end

    it 'is clean username' do
      expect(subject.username_changed?).to eq false
    end
  end
end
