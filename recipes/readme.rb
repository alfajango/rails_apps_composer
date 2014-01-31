# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/readme.rb

after_everything do
  say_wizard "recipe running after everything"

  # remove default READMEs
  %w{
    README
    README.rdoc
    doc/README_FOR_APP
  }.each { |file| remove_file file }

  # add placeholder READMEs and humans.txt file
  copy_from_repo 'public/humans.txt'
  copy_from_repo 'README'
  copy_from_repo 'README.textile'
  gsub_file "README", /App_Name/, "#{app_name.humanize.titleize}"
  gsub_file "README.textile", /App_Name/, "#{app_name.humanize.titleize}"

  # Diagnostics
  gsub_file "README.textile", /recipes that are known/, "recipes that are NOT known" if diagnostics[:recipes] == 'fail'
  gsub_file "README.textile", /preferences that are known/, "preferences that are NOT known" if diagnostics[:prefs] == 'fail'
  print_recipes = recipes.sort.map { |r| "\n* #{r}" }.join('')
  print_preferences = prefs.map { |k, v| "\n* #{k}: #{v}" }.join('')
  gsub_file "README.textile", /RECIPES/, print_recipes
  gsub_file "README.textile", /PREFERENCES/, print_preferences
  gsub_file "README", /RECIPES/, print_recipes
  gsub_file "README", /PREFERENCES/, print_preferences

  # Ruby on Rails
  gsub_file "README.textile", /\* Ruby/, "* Ruby version #{RUBY_VERSION}"
  gsub_file "README.textile", /\* Rails/, "* Rails version #{Rails::VERSION::STRING}"

  # Database
  gsub_file "README.textile", /SQLite/, "PostgreSQL" if prefer :database, 'postgresql'
  gsub_file "README.textile", /SQLite/, "MySQL" if prefer :database, 'mysql'
  gsub_file "README.textile", /SQLite/, "MongoDB" if prefer :database, 'mongodb'
  gsub_file "README.textile", /ActiveRecord/, "the Mongoid ORM" if prefer :orm, 'mongoid'

  # Template Engine
  gsub_file "README.textile", /ERB/, "Haml" if prefer :templates, 'haml'
  gsub_file "README.textile", /ERB/, "Slim" if prefer :templates, 'slim'

  # Testing Framework
  gsub_file "README.textile", /Test::Unit/, "RSpec" if prefer :unit_test, 'rspec'
  gsub_file "README.textile", /RSpec/, "RSpec and Cucumber" if prefer :integration, 'cucumber'
  gsub_file "README.textile", /RSpec/, "RSpec and Factory Girl" if prefer :fixtures, 'factory_girl'
  gsub_file "README.textile", /RSpec/, "RSpec and Machinist" if prefer :fixtures, 'machinist'

  # Front-end Framework
  gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Twitter Bootstrap 2.3 (Sass)" if prefer :frontend, 'bootstrap2'
  gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Twitter Bootstrap 3.0 (Sass)" if prefer :frontend, 'bootstrap3'
  gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Zurb Foundation 4" if prefer :frontend, 'foundation4'
  gsub_file "README.textile", /Front-end Framework: None/, "Front-end Framework: Zurb Foundation 5" if prefer :frontend, 'foundation5'

  # Form Builder
  gsub_file "README.textile", /Form Builder: None/, "Form Builder: SimpleForm" if prefer :form_builder, 'simple_form'

  # Email
  unless prefer :email, 'none'
    gsub_file "README.textile", /Gmail/, "SMTP" if prefer :email, 'smtp'
    gsub_file "README.textile", /Gmail/, "SendGrid" if prefer :email, 'sendgrid'
    gsub_file "README.textile", /Gmail/, "Mandrill" if prefer :email, 'mandrill'
  else
    gsub_file "README.textile", /h2. Email/, ""
    gsub_file "README.textile", /The application is configured to send email using a Gmail account./, ""
  end

  # Authentication and Authorization
  gsub_file "README.textile", /Authentication: None/, "Authentication: Devise" if prefer :authentication, 'devise'
  gsub_file "README.textile", /Authentication: None/, "Authentication: OmniAuth" if prefer :authentication, 'omniauth'
  gsub_file "README.textile", /Authorization: None/, "Authorization: CanCan" if prefer :authorization, 'cancan'

  # Admin
  append_file "README.textile", "\nh2. Admin\n\n Admin: ActiveAdmin" if prefer :admin, 'activeadmin'
  append_file "README.textile", "\nh2. Admin\n\n Admin: RailsAdmin" if prefer :admin, 'rails_admin'

  git :add => '-A' if prefer :git, true
  git :commit => '-qm "Generated README files."' if prefer :git, true

end # after_everything

__END__

name: readme
description: "Build a README file for your application."
author: RailsApps

requires: [setup]
run_after: [setup]
category: configuration
