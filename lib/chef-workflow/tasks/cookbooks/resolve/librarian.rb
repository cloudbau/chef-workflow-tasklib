begin
  Rake::Task["cookbooks:resolve"].clear
  Rake::Task["cookbooks:update"].clear
rescue
end

require 'chef-workflow/tasks/bootstrap/knife'
require 'chef-workflow/tasks/cookbooks/resolve_and_upload'

# Both berkshelf and librarian have ... aggressive dependencies. They usually are
# a great way to break your Gemfile if you have chef in it.
namespace :cookbooks do
  desc "Resolve cookbooks and populate #{KnifeSupport.cookbooks_path} using Librarian"
  task :resolve => [ "bootstrap:knife" ] do
    Bundler.with_clean_env do
      sh "librarian-chef install --path #{KnifeSupport.cookbooks_path} -c #{KnifeSupport.knife_config_path}"
    end
  end

  desc "Update your locked cookbooks with Librarian"
  task :update => [ "bootstrap:knife" ] do
    Bundler.with_clean_env do
      sh "librarian-chef update"
    end
  end
end