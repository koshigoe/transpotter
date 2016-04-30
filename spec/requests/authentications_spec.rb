require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  describe 'POST /v1.0/authentications' do
    subject do
      post '/v1.0/authentications',
           params: params.to_json,
           headers: { 'Content-Type' => 'application/vnd.api+json' }
    end

    let(:user) { create(:user) }
    let(:valid_params) do
      {
        data: {
          type: 'authentications',
          attributes: {
            username: user.username,
            password: 'password',
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
            id: user.id.to_s,
            type: 'authentications',
            attributes: {
              token: String
            }
          }
        end
      end
    end

    context 'error' do
      context 'required parameter missing' do
        let(:params) { { data: {} } }

        it_behaves_like 'HTTP 400 Bad Request'
        it_behaves_like 'JSON API with /errors' do
          let(:errors) do
            [{ title: 'required parameter missing', status: 400 }]
          end
        end
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

      context 'user not found' do
        before { user.destroy }

        let(:params) { valid_params }

        it_behaves_like 'HTTP 401 Unauthorized'
        it_behaves_like 'JSON API with /errors' do
          let(:errors) do
            [{ title: 'Incorrect username or password', status: 401 }]
          end
        end
      end

      context 'incorrect password' do
        let(:params) do
          valid_params.tap do |x|
            x[:data][:attributes][:password] = 'incorrect'
          end
        end

        it_behaves_like 'HTTP 401 Unauthorized'
        it_behaves_like 'JSON API with /errors' do
          let(:errors) do
            [{ title: 'Incorrect username or password', status: 401 }]
          end
        end
      end
    end
  end
end
