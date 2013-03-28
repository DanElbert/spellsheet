
set :application, "spellsheet"

# RVM Config
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system

# Source code
set :scm, :git
set :repository, "git@github.com:DanElbert/spellsheet.git"
set :branch, "master"

# Web Server Config
set :deploy_to, "/var/www-apps/#{application}"

role :web, "azathoth"                          # Your HTTP server, Apache/etc
role :app, "azathoth"                          # This may be the same as your `Web` server
role :db,  "azathoth", :primary => true # This is where Rails migrations will run

require "rvm/capistrano"
require "bundler/capistrano"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end
