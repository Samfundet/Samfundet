# -*- encoding : utf-8 -*-
=begin
This file should contain all the record creation needed to seed the database with its default values.
The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

This seed file makes use of "Seedbank":
https://github.com/james2m/seedbank

Examples of rake tasks to run:
rake db:seed
Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/ENVIRONMENT/*.seeds.rb.

rake db:seed:bar                # Load the seed data from db/seeds/bar.seeds.rb
rake db:seed:common             # Load the seed data from db/seeds.rb and db/seeds/*.seeds.rb.
rake db:seed:development        # Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/development/*.seeds.rb.
rake db:seed:development:users  # Load the seed data from db/seeds/development/users.seeds.rb
rake db:seed:original           # Load the seed data from db/seeds.rb

Structure:

seeds.rb                        # wipes database for local dev
- generate roles
    - applicants
- create external organizers
    - admissions + jobs
- images
    - documents
        - pages
- sulten

/development                    # DEVELOPMENT environment
- truncate (first task)
- billig events + price groups
- member cards


Truncating tables can be run by `make truncate`
Development seed is run by `make localseed`


=end
after "development:truncate" do
  puts "Initializing seedbank"
end