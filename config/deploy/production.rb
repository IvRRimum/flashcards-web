server 'crypto-tzar-deploy', port: 22, roles: [:web, :app, :db], primary: true
set :rvm_ruby_string, '3.1.1' # you probably have this already
set :rvm_type, :user
set :application, 'chinese-flashcards-web'
set :repo_url, 'git@github.com:IvRRimum/chinese-flashcards-web.git'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :bundle_binstubs, nil

set :console_user, 'deploy'

# Don't change these unless you know what you're doing
set :pty,             false
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { 
  forward_agent: true,
  user: fetch(:user),
  keys: %w(~/.ssh/crypto-tzar),
  auth_methods: %w(publickey)
}
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
set :branch, "main"

set :linked_files, %w{config/database.yml config/credentials.yml.enc config/master.key}
set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system storage}

#set :sidekiq_config, "config/sidekiq.yml"

namespace :puma do
  Rake::Task[:restart].clear_actions

  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs


  desc "Overwritten puma:restart task"
  task :restart do
    puts "Overwriting puma:restart to ensure that puma is running. Effectively, we are just starting Puma."
    puts "A solution to this should be found."
    invoke 'puma:stop'
    invoke 'puma:start'
  end
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/main`
        puts "WARNING: HEAD is not the same as origin/main"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :restart_sidekiq
  after  :finishing,    :cleanup
end
