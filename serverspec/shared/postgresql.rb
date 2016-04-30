shared_examples_for 'PostgreSQL' do
  describe package 'postgresql95' do
    it { should be_installed }
  end

  describe package 'postgresql95-server' do
    it { should be_installed }
  end

  describe package 'postgresql95-devel' do
    it { should be_installed }
  end

  describe package 'postgresql95-contrib' do
    it { should be_installed }
  end

  describe service 'postgresql-9.5' do
    it { should be_enabled }
    it { should be_running }
  end

  describe file '/var/lib/pgsql/9.5/data/pg_hba.conf' do
    it { should be_file }
    it { should be_owned_by 'postgres' }
    it { should be_grouped_into 'postgres' }
    it { should be_mode 600 }
  end

  describe file '/var/lib/pgsql/9.5/data/pg_ident.conf' do
    it { should be_file }
    it { should be_owned_by 'postgres' }
    it { should be_grouped_into 'postgres' }
    it { should be_mode 600 }
  end

  describe file '/var/lib/pgsql/9.5/data/postgresql.auto.conf' do
    it { should be_file }
    it { should be_owned_by 'postgres' }
    it { should be_grouped_into 'postgres' }
    it { should be_mode 600 }
  end

  describe file '/var/lib/pgsql/9.5/data/postgresql.conf' do
    it { should be_file }
    it { should be_owned_by 'postgres' }
    it { should be_grouped_into 'postgres' }
    it { should be_mode 600 }
  end
end
