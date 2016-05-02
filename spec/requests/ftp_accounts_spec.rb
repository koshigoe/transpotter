require 'rails_helper'

RSpec.describe 'FTPAccounts', type: :request do
  let(:user) { create(:user) }

  describe 'GET /v1.0/ftp-accounts/:id' do
    subject do
      get "/v1.0/ftp-accounts/#{ftp_account.id}",
          headers: { 'Authorization' => "Token #{user.token}" }
    end

    let(:ftp_account) { create(:ftp_account) }

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
            [{ title: 'FTP account not found', status: 404 }]
          end
        end
      end
    end
  end

  describe 'POST /v1.0/ftp-accounts' do
    subject do
      post '/v1.0/ftp-accounts',
           params: params.to_json,
           headers: {
             'Content-Type' => 'application/vnd.api+json',
             'Authorization' => "Token #{user.token}"
           }
    end

    let(:valid_params) do
      {
        data: {
          type: 'ftpAccount',
          attributes: {
            password: 'password'
          }
        }
      }
    end

    context 'successful' do
      let(:params) { valid_params }

      it_behaves_like 'HTTP 200 OK'
      it_behaves_like 'JSON API with /data' do
        let(:data) do
          {
            id: /\A\d+\z/,
            type: 'ftpAccount',
            attributes: {
              username: /\Aftp-\d+\z/,
              uid: 1000,
              gid: 1000,
              homedir: '/home/vagrant',
              shell: ''
            }
          }
        end
      end

      it 'created FTPAccount' do
        expect { subject }.to change(FTPAccount, :count).by(1)
      end
    end

    context 'error' do
      context 'unauthorized' do
        subject { post '/v1.0/ftp-accounts' }
        it_behaves_like 'Unauthorized'
      end

      context 'wrong /data/type' do
        let(:params) do
          valid_params.tap do |x|
            x[:data][:type] = 'invalid'
          end
        end

        it_behaves_like 'HTTP 400 Bad Request'
        it_behaves_like 'JSON API with /errors' do
          let(:errors) do
            [{ title: 'Invalid type', status: 400 }]
          end
        end
      end

      context 'empty password' do
        let(:params) do
          valid_params.tap do |x|
            x[:data][:attributes][:password] = ''
          end
        end

        it_behaves_like 'HTTP 422 Unprocessable Entity'
        it_behaves_like 'JSON API with /errors' do
          let(:errors) do
            [
              {
                status: 422,
                title: 'Password can\'t be blank',
                source: { pointer: '/data/attributes/password' }
              }
            ]
          end
        end
      end
    end
  end

  describe 'PUT /v1.0/ftp-accounts/:id' do
    let!(:ftp_account) { create(:ftp_account) }
    let(:valid_params) do
      {
        data: {
          id: ftp_account.id.to_s,
          type: 'ftpAccount',
          attributes: {
            password: 'newpassword'
          }
        }
      }
    end

    subject do
      put "/v1.0/ftp-accounts/#{ftp_account.id}",
          params: params.to_json,
          headers: {
            'Content-Type' => 'application/vnd.api+json',
            'Authorization' => "Token #{user.token}"
          }
    end

    context 'successful' do
      context 'present password' do
        let(:params) { valid_params }

        it_behaves_like 'HTTP 200 OK'
        it_behaves_like 'JSON API with /data' do
          let(:data) do
            {
              id: ftp_account.id.to_s,
              type: 'ftpAccount',
              attributes: {
                username: "ftp-#{ftp_account.id}",
                uid: 1000,
                gid: 1000,
                homedir: '/home/vagrant',
                shell: ''
              }
            }
          end
        end

        it 'does not increase record' do
          expect { subject }.not_to change(FTPAccount, :count)
        end

        it 'change password_digest' do
          expect { subject }.to change { ftp_account.reload.password_digest }
        end
      end

      context 'empty password' do
        let(:params) do
          valid_params.tap do |x|
            x[:data][:attributes][:password] = ''
          end
        end

        it_behaves_like 'HTTP 200 OK'
        it_behaves_like 'JSON API with /data' do
          let(:data) do
            {
              id: ftp_account.id.to_s,
              type: 'ftpAccount',
              attributes: {
                username: "ftp-#{ftp_account.id}",
                uid: 1000,
                gid: 1000,
                homedir: '/home/vagrant',
                shell: ''
              }
            }
          end
        end

        it 'does not increase record' do
          expect { subject }.not_to change(FTPAccount, :count)
        end

        it 'does not change password_digest' do
          expect { subject }.not_to change { ftp_account.reload.password_digest }
        end
      end
    end

    context 'error' do
      context 'unauthorized' do
        subject { put "/v1.0/ftp-accounts/#{ftp_account.id}" }
        it_behaves_like 'Unauthorized'
      end

      context 'wrong /data/type' do
        let(:params) do
          valid_params.tap do |x|
            x[:data][:type] = 'invalid'
          end
        end

        it_behaves_like 'HTTP 400 Bad Request'
        it_behaves_like 'JSON API with /errors' do
          let(:errors) do
            [{ title: 'Invalid type', status: 400 }]
          end
        end
      end

      context 'ftp account not found' do
        before { ftp_account.destroy }

        let(:params) { valid_params }

        it_behaves_like 'HTTP 404 Not Found'
        it_behaves_like 'JSON API with /errors' do
          let(:errors) do
            [{ title: 'FTP account not found', status: 404 }]
          end
        end
      end
    end
  end

  describe 'DELETE /v1.0/ftp-accounts/:id' do
    let!(:ftp_account) { create(:ftp_account) }
    let(:valid_params) do
      {
        data: {
          id: ftp_account.id.to_s,
          type: 'ftpAccount',
        }
      }
    end

    subject do
      delete "/v1.0/ftp-accounts/#{ftp_account.id}",
             params: params.to_json,
             headers: {
               'Content-Type' => 'application/vnd.api+json',
               'Authorization' => "Token #{user.token}"
             }
    end

    context 'successful' do
      let(:params) { valid_params }

      context 'ftp account exists' do
        it_behaves_like 'HTTP 200 OK'
        it_behaves_like 'JSON API with /data' do
          let(:data) { nil }
        end

        it 'decrease record' do
          expect { subject }.to change(FTPAccount, :count).by(-1)
        end

        it 'specified ftp account destroyed' do
          expect { subject }.to change { FTPAccount.where(id: ftp_account.id).exists? }.to(false)
        end
      end

      context 'ftp account does not exist' do
        before { ftp_account.destroy }

        it_behaves_like 'HTTP 200 OK'
        it_behaves_like 'JSON API with /data' do
          let(:data) { nil }
        end

        it 'does not decrease record' do
          expect { subject }.not_to change(FTPAccount, :count)
        end
      end
    end

    context 'error' do
      context 'unauthorized' do
        subject { delete "/v1.0/ftp-accounts/#{ftp_account.id}" }
        it_behaves_like 'Unauthorized'
      end

      context 'wrong /data/type' do
        let(:params) do
          valid_params.tap do |x|
            x[:data][:type] = 'invalid'
          end
        end

        it_behaves_like 'HTTP 400 Bad Request'
        it_behaves_like 'JSON API with /errors' do
          let(:errors) do
            [{ title: 'Invalid type', status: 400 }]
          end
        end
      end
    end
  end
end
