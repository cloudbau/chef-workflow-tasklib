require 'chef-workflow/support/knife'

ChefWorkflow::KnifeSupport.add_attribute :fc_cookbooks_path, File.join(Dir.pwd, 'cookbooks')
ChefWorkflow::KnifeSupport.add_attribute :fc_options, [ ]

namespace :chef do
  namespace :cookbooks do
    desc "Run the cookbooks through foodcritic"
    task :foodcritic do
      resolve_task = Rake::Task["chef:cookbooks:resolve"] rescue nil
      resolve_task.invoke if resolve_task

      if File.directory?(ChefWorkflow::KnifeSupport.fc_cookbooks_path)
        Bundler.with_clean_env do
          sh "foodcritic #{ChefWorkflow::KnifeSupport.fc_cookbooks_path} #{ChefWorkflow::KnifeSupport.fc_options.join(" ")}"
        end
      end
    end
  end
end
