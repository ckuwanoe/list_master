 namespace :utilities do
  desc "adding user via command line"
  task :new_user, [:email, :first_name, :last_name, :password, :state, :region_id, :role_id] => :environment do |t, args|
    success = User.create!(email: "#{args.email}", first_name: "#{args.first_name}", last_name: "#{args.last_name}", password: "#{args.password}", state: "#{args.state}", region_id: "#{args.region_id}", role_id: "#{args.role_id}")
  end
end
