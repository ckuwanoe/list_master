namespace :links do
  desc "Symlink the spreadsheets dir"
  task :symlink_spreadsheets, roles: :app do
    run "rm -rf #{current_release}/public/spreadsheets"
    run "ln -s #{shared_path}/spreadsheets #{current_release}/public/spreadsheets"
  end
  after "deploy:finalize_update", "links:symlink_spreadsheets"

  desc "Symlink the mail config file"
  task :symlink_setup_mail, roles: :app do
    run "ln -s #{shared_path}/config/setup_mail.rb #{current_release}/config/initializers/setup_mail.rb"
  end
  after "deploy:finalize_update", "links:symlink_setup_mail"
end
