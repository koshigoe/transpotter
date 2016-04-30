shared_examples_for 'HTTP 200 OK' do
  it 'is 200 OK' do
    subject
    expect(response).to have_http_status 200
  end
end

shared_examples_for 'HTTP 400 Bad Request' do
  it 'is 400 Bad Request' do
    subject
    expect(response).to have_http_status 400
  end
end

shared_examples_for 'HTTP 401 Unauthorized' do
  it 'is 401 Unauthorized' do
    subject
    expect(response).to have_http_status 401
  end
end

shared_examples_for 'HTTP 404 Not Found' do
  it 'is 404 Not Found' do
    subject
    expect(response).to have_http_status 404
  end
end

shared_examples_for 'JSON API with /data' do
  it 'includes Content-Type: application/vnd.api+json' do
    subject
    expect(response.headers['Content-Type']).to eq 'application/vnd.api+json'
  end

  it 'match /data' do
    subject
    expect(response.body).to be_json_including(data: data)
  end
end

shared_examples_for 'JSON API with /errors' do
  it 'includes Content-Type: application/vnd.api+json' do
    subject
    expect(response.headers['Content-Type']).to eq 'application/vnd.api+json'
  end

  it 'match /data' do
    subject
    expect(response.body).to be_json_as(errors: errors)
  end
end

shared_examples_for 'Unauthorized' do
  it_behaves_like 'HTTP 401 Unauthorized'
  it_behaves_like 'JSON API with /errors' do
    let(:errors) do
      [{ title: 'HTTP Token: Access denied', status: 401 }]
    end
  end

  it 'include WWW-Authenticate:' do
    subject
    expect(response.headers['WWW-Authenticate']).to eq 'Token realm="Application"'
  end
end
