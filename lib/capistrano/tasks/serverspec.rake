task :serverspec do
  on roles(:all) do
    roles = host.roles.to_a
    target = host.hostname
    ssh_config = host.ssh_options[:config]

    run_locally do
      with target_host: target, ssh_config: ssh_config do
        roles.each do |role|
          execute :rspec, "serverspec/roles/#{role}_spec.rb"
        end
      end
    end
  end
end
