if Rails.env.production?
  Dumper::Agent.start(:app_key => 'kbj1pnSek1h5ejR02yMjiA')
end
