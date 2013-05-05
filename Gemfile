source 'https://rubygems.org'

gemspec

group :development, :test do
  gem "rspec"
  #gem "bson"
  #gem "mongoid"

  unless ENV["CI"]
    gem "guard-rspec"
  end
end
