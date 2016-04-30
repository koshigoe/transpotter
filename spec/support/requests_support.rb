shared_examples_for 'HTTP 200 OK' do
  it 'is 200 OK' do
    subject
    expect(response).to have_http_status 200
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
