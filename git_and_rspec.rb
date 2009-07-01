# Delete unnecessary files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
  

["./tmp/pids", "./tmp/sessions", "./tmp/sockets", "./tmp/cache"].each do |f|
  run("rmdir ./#{f}")
end
 
# git:hold_empty_dirs
run("find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;")
 
# git:rails:new_app
git :init
 
initializer '.gitignore', <<-CODE
log/\\*.log
log/\\*.pid
db/\\*.db
db/\\*.sqlite3
db/schema.rb
tmp/\\*\\*/\\*
.DS_Store
doc/api
doc/app
config/database.yml
CODE
 
run "cp config/database.yml config/database.yml.sample"
 
git :add => "."
 
git :commit => "-a -m 'Setting up a new rails app. Copy config/database.yml.sample to config/database.yml and customize.'"

        

# regular plugins 
plugin 'rspec', :git => 'git://github.com/dchelimsky/rspec.git'
plugin 'rspec-rails', :git => 'git://github.com/dchelimsky/rspec-rails.git'
plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication.git'
plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication.git'
plugin 'exception_notifier', :git => 'git://github.com/rails/exception_notification.git'


# gems  
gem 'mislav-will_paginate'
gem 'ruby-openid'
gem 'rubyist-aasm'      
rake "gems:install", :sudo => true
 
# gems  
rakefile "bootstrap.rake", <<CODE
  namespace :app do
    task :bootstrap do
    end
    
    task :seed do
    end
  end
CODE
 
generate("authenticated", "user session")
generate("rspec")