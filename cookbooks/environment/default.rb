node.validate! do
  {
    transpotter: {
      s3_bucket: string,
    }
  }
end

template '/etc/environment' do
  owner 'root'
  group 'root'
  mode '0644'
end
