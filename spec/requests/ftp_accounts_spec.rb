require 'rails_helper'

RSpec.describe 'FtpAccounts', type: :request do
  describe 'GET /v1.0/ftp-accounts/:id' do
    subject do
      get "/v1.0/ftp-accounts/#{ftp_account.id}",
          headers: { 'Authorization' => "Token #{user.token}" }
    end

    let(:ftp_account) { create(:ftp_account) }
    let(:user) { create(:user) }

    context 'successful' do
      it_behaves_like 'HTTP 200 OK'
      it_behaves_like 'JSON API with /data' do
        let(:data) do
          {
            id: ftp_account.id.to_s,
            type: 'ftpAccount',
            attributes: {
              username: ftp_account.username,
              uid: 1000,
              gid: 1000,
              homedir: '/home/vagrant',
              shell: ''
            }
          }
        end
      end
    end

    context 'error' do
      context 'unauthorized' do
        subject { get "/v1.0/ftp-accounts/#{ftp_account.id}" }
        it_behaves_like 'Unauthorized'
      end

      context 'ftp account not found' do
        before { ftp_account.destroy }

        it_behaves_like 'HTTP 404 Not Found'
        it_behaves_like 'JSON API with /errors' do
          let(:errors) do
            [{ title: 'Ftp account not found', status: 404 }]
          end
        end
      end
    end
  end
end
