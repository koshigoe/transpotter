shared_examples_for 'ProFTPDAccounts show' do
  let(:user) { create(:user) }

  subject do
    get "/v1.0/#{scheme}-accounts/#{account.id}",
        headers: { 'Authorization' => "Token #{user.token}" }
  end

  let(:account) { create("#{scheme}_account") }

  context 'successful' do
    it_behaves_like 'HTTP 200 OK'
    it_behaves_like 'JSON API with /data' do
      let(:data) do
        {
          id: account.id.to_s,
          type: "#{scheme}Account",
          attributes: {
            username: account.username,
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
      subject { get "/v1.0/#{scheme}-accounts/#{account.id}" }
      it_behaves_like 'Unauthorized'
    end

    context 'account not found' do
      before { account.destroy }

      it_behaves_like 'HTTP 404 Not Found'
      it_behaves_like 'JSON API with /errors' do
        let(:errors) do
          [{ title: "#{scheme.upcase} account not found", status: 404 }]
        end
      end
    end
  end
end

shared_examples_for 'ProFTPDAccounts create' do
  let(:user) { create(:user) }

  subject do
    post "/v1.0/#{scheme}-accounts",
         params: params.to_json,
         headers: {
           'Content-Type' => 'application/vnd.api+json',
           'Authorization' => "Token #{user.token}"
         }
  end

  let(:valid_params) do
    {
      data: {
        type: "#{scheme}Account",
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
          type: "#{scheme}Account",
          attributes: {
            username: /\A#{scheme}-\d+\z/,
            uid: 1000,
            gid: 1000,
            homedir: '/home/vagrant',
            shell: ''
          }
        }
      end
    end

    it 'create account' do
      expect { subject }.to change("#{scheme}_account".classify.constantize, :count).by(1)
    end
  end

  context 'error' do
    context 'unauthorized' do
      subject { post "/v1.0/#{scheme}-accounts" }
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

shared_examples_for 'ProFTPDAccounts update' do
  let(:user) { create(:user) }
  let!(:account) { create("#{scheme}_account") }
  let(:valid_params) do
    {
      data: {
        id: account.id.to_s,
        type: "#{scheme}Account",
        attributes: {
          password: 'newpassword'
        }
      }
    }
  end

  subject do
    put "/v1.0/#{scheme}-accounts/#{account.id}",
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
            id: account.id.to_s,
            type: "#{scheme}Account",
            attributes: {
              username: "#{scheme}-#{account.id}",
              uid: 1000,
              gid: 1000,
              homedir: '/home/vagrant',
              shell: ''
            }
          }
        end
      end

      it 'does not increase record' do
        expect { subject }.not_to change("#{scheme}_account".classify.constantize, :count)
      end

      it 'change password_digest' do
        expect { subject }.to change { account.reload.password_digest }
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
            id: account.id.to_s,
            type: "#{scheme}Account",
            attributes: {
              username: "#{scheme}-#{account.id}",
              uid: 1000,
              gid: 1000,
              homedir: '/home/vagrant',
              shell: ''
            }
          }
        end
      end

      it 'does not increase record' do
        expect { subject }.not_to change("#{scheme}_account".classify.constantize, :count)
      end

      it 'does not change password_digest' do
        expect { subject }.not_to change { account.reload.password_digest }
      end
    end
  end

  context 'error' do
    context 'unauthorized' do
      subject { put "/v1.0/#{scheme}-accounts/#{account.id}" }
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

    context 'account not found' do
      before { account.destroy }

      let(:params) { valid_params }

      it_behaves_like 'HTTP 404 Not Found'
      it_behaves_like 'JSON API with /errors' do
        let(:errors) do
          [{ title: "#{scheme.upcase} account not found", status: 404 }]
        end
      end
    end
  end
end

shared_examples_for 'ProFTPDAccounts destroy' do
  let(:user) { create(:user) }
  let!(:account) { create("#{scheme}_account") }
  let(:valid_params) do
    {
      data: {
        id: account.id.to_s,
        type: "#{scheme}Account",
      }
    }
  end

  subject do
    delete "/v1.0/#{scheme}-accounts/#{account.id}",
           params: params.to_json,
           headers: {
             'Content-Type' => 'application/vnd.api+json',
             'Authorization' => "Token #{user.token}"
           }
  end

  context 'successful' do
    let(:params) { valid_params }

    context 'account exists' do
      it_behaves_like 'HTTP 200 OK'
      it_behaves_like 'JSON API with /data' do
        let(:data) { nil }
      end

      it 'decrease record' do
        expect { subject }.to change("#{scheme}_account".classify.constantize, :count).by(-1)
      end

      it 'specified account destroyed' do
        expect { subject }.to change { "#{scheme}_account".classify.constantize.where(id: account.id).exists? }.to(false)
      end
    end

    context 'account does not exist' do
      before { account.destroy }

      it_behaves_like 'HTTP 200 OK'
      it_behaves_like 'JSON API with /data' do
        let(:data) { nil }
      end

      it 'does not decrease record' do
        expect { subject }.not_to change("#{scheme}_account".classify.constantize, :count)
      end
    end
  end

  context 'error' do
    context 'unauthorized' do
      subject { delete "/v1.0/#{scheme}-accounts/#{account.id}" }
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
