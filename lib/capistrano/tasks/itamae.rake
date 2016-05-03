namespace :itamae do
  task :run do
    dispatch
  end

  task :dry_run do
    dispatch(dry_run: true)
  end

  def dispatch(opts = {})
    on roles(:all) do
      roles = host.roles.to_a
      target = host.hostname
      ssh_config = host.ssh_options[:config]

      run_locally do
        execute :aws, :s3, :cp, '--recursive', '--quiet', "s3://#{fetch(:secrets_bucket)}/", '.secrets/'
        with target_host: target, ssh_config: ssh_config do
          roles.each do |role|
            dry_run_option = opts[:dry_run] ? '--dry-run' : ''
            execute :itamae, :ssh, dry_run_option, "--ssh-config #{ssh_config}", "-h #{target}", "-y nodes/#{fetch(:stage)}-#{role}.yml", "roles/#{role}.rb"
          end
        end
      end
    end
  end
end

task :itamae do
  invoke 'itamae:run'
end
