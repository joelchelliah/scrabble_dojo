Getting started:
---------------

- install ruby version specified in `.ruby-version`

- Verify that gemset according to `.ruby-version` and `.ruby-gemset` is created

- `bundle install --without production`
  * because installing '**pg**' locally is a lot of trouble, and we don't need it

- Create a basic '**config/database.yml**' file: [sample](https://gist.github.com/danopia/940155)
  * No need to specify production since this file is not checked in (Heroku has its own way of doing things).

- Database re-initialization:
  * `rake db:create`
  * `rake db:schema:load`
  * Verify that everything is **UP** with: `rake db:migrate:status`


- Run tests:
  * Setup test DB with: `rake db:migrate RAILS_ENV=test`
  * Run tests: `rspec`
  * Say hi to **NYAN CAT**

 
- Deploying to Heroku:
  * Add remote: `heroku git:remote -a scrabbledojo`
  * Deploy: `git push heroku master`


- Populate local database:
  * **Either** : [copy data from heroku's database](http://manuel.manuelles.nl/blog/2012/01/18/convert-postgresql-to-sqlite/)
  * Or generate data from dictionary:
    * run `ordliste/gen-db-seeds.rb` to generate seed data
    * run `rake db:seed` to populate **WordEntry** table with seed data (...Takes a while!)
    * run `rake db:add_probability` to update **WordEntry** rows' probability column
    * create new test-user through app
