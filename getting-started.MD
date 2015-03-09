
- If ruby-2.1.0 is not installed: `rvm install ruby-2.1.0`

- Verify that gemset '**ruby-2.1.0@scrabbledojo**' is created.

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

 
- Make stuff!


- Deploying to Heroku:
  * Add remote: `heroku git:remote -a scrabbledojo`
  * Deploy: `git push heroku master`
