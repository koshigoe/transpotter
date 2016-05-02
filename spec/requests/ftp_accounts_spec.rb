require 'rails_helper'

RSpec.describe 'FTPAccounts', type: :request do
  describe 'GET /v1.0/ftp-accounts/:id' do
    it_behaves_like 'ProFTPDAccounts show' do
      let(:scheme) { 'ftp' }
    end
  end

  describe 'POST /v1.0/ftp-accounts' do
    it_behaves_like 'ProFTPDAccounts create' do
      let(:scheme) { 'ftp' }
    end
  end

  describe 'PUT /v1.0/ftp-accounts/:id' do
    it_behaves_like 'ProFTPDAccounts update' do
      let(:scheme) { 'ftp' }
    end
  end

  describe 'DELETE /v1.0/ftp-accounts/:id' do
    it_behaves_like 'ProFTPDAccounts destroy' do
      let(:scheme) { 'ftp' }
    end
  end
end
