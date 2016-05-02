require 'rails_helper'

RSpec.describe 'SFTPAccounts', type: :request do
  describe 'GET /v1.0/sftp-accounts/:id' do
    it_behaves_like 'ProFTPDAccounts show' do
      let(:scheme) { 'sftp' }
    end
  end

  describe 'POST /v1.0/sftp-accounts' do
    it_behaves_like 'ProFTPDAccounts create' do
      let(:scheme) { 'sftp' }
    end
  end

  describe 'PUT /v1.0/sftp-accounts/:id' do
    it_behaves_like 'ProFTPDAccounts update' do
      let(:scheme) { 'sftp' }
    end
  end

  describe 'DELETE /v1.0/sftp-accounts/:id' do
    it_behaves_like 'ProFTPDAccounts destroy' do
      let(:scheme) { 'sftp' }
    end
  end
end
