# Stuffmapper Development Readme




### Prerequisites:


#### Ruby Version


We're using ruby-2.2.0 on this site. To check you're version. Type `ruby -v` in the command line.
downgrade
if you need to upgrade or downgrade. Checkout [RVM](https://rvm.io/) or [rbenv](https://github.com/sstephenson/rbenv) as options for your ruby version management. Either one should work with. There is a .ruby-version file included that either system should be able to use.



####For Linux Fedora


ImageMagick also needs to installed.



```
$ sudo yum install gcc gcc-c++ git ruby ruby-devel

$ sudo yum install postgresql postgresql-server postgresql-devel

$ sudo yum install mysql-devel sqlite3x-devel libyaml-devel nodejs

$ sudo gem update

$ sudo gem update  --system

$ sudo gem install rails sqlite3-ruby pg phantomjs-binaries rdoc-data

$ rdoc-data --install

```



####For Mac

I recommend that you use [homebrew](http://brew.sh/) to install things like ImageMagick if it's not already installed.

Postgressql is required to run the database. If you don't already have it running, I suggest [postgressapp.com](http://postgresapp.com/) . It's probably the easiest way to get it running

If you're looking for other options, you can checkout [this site](http://www.gotealeaf.com/blog/how-to-install-postgresql-on-a-mac)



### Database Setup

##### Postgres installation for Linux:

```
$ sudo -u postgres psql		*# Postgres terminal*

postgres=# \password		*# Prompts you for psql password*

postgres=# create user "<**username**>" with password '<**password**>';

postgres=# alter user <**username**> superuser;

postgres=# create database "dibsley_development";

postgres=# create database "dibsley_test";

postgres=# grant all privileges on database dibsley_development to <username>;

postgres=# grant all privileges on database dibsley_test to <username>;
```

*Ctrl+D to exit postgres command line*

#####  Database installation for Mac:
  - after making sure that postgres is installed

  - create a superuser in postgres to manage that test & development databases on your computer:
  `createuser yourusername -s -d`

  - set up environment variables for the test & dev databases

  - something like this in your ~/.bash_profile file:

```

export STFMP_TEST_USER="yourusername"
export STFMP_TEST_PASS=""

export STFMP_DEV_USER="yourusername"
export STFMP_DEV_PASS=""

```
 - run `. ~/.bash_profile` to make those changes active



### Run the site

After going throught the perquisites

- in the root directory in the command line
- `bundle install`
- `rake db:create `
- `rake db:migrate RAILS_ENV=development`
- `rails s`
- The site should be running on at localhost:3000



### Git work flow:

Create your own branch and keep it up to date with the master branch.

Commit often and pull from masters often. Before pushing to the development branch, all tests should be passing. New features should not be pushed to the branch without tests in place.  

For new features that we're collaborating on. The most important thing to remember is to pull often and push often before getting to far into a change. There's no reason that we should be accidentally stomping on other's code.

Unless your collaborating to fix an issue, tests should be created and passing before pushing to a branch.

-- this is a work in progress. More specifics will be added as we figure out what is working best for the team.




### Front End Dependencies

This uses bower to install front end dependencies. You can still use gems for this but I found that bower offers more access to other libraries and slightly more flexibility.

To add new libraries, declare them in the `Bowerfile` in the root directory. and run.

 	rake bower:install

 The files will be stored in the director `vendor/assets/bower_components` and then included on the page through `app/assets/javascripts/application.js`

To get angular and rails working on the site, the instructions on [angular-rails.com](http://www.angular-rails.com) were strictly followed. Some things will be implemented the slightly different . But is should be a good read through to understand why this site was set up the way it was.




The local code for the angular features can be found in `app/assets/javascripts` and are written in coffee script.




###Testing

  for continuous testing

  `guard`

  to run the entire suite of tests

  `rake`

  to run the just the rspec tests

  `bundle exec rake rspec`

 rspec tests can be found in the `spec/` folder

  to only run the end to end tests

  `bundle exec rake cucumber`

  cucumber tests can be found in the `features/` folder
  the capybara step definitions can be found in the `features/step_definitons` folder

 As of writing this readme, the tests for the javascript/angular code is not running. It is important that they get running at some point and I encourage anyone to write more tests and get them running.

 #notes on dib
  remove a current dib
  add a status field to dib to report information
  reset dib status

### BoundingBox

The code for creating the boundingbox in map service for points was adapted from
[this guy](http://www.movable-type.co.uk/scripts/latlong.html)

### JWT storage

https://stormpath.com/blog/where-to-store-your-jwts-cookies-vs-html5-web-storage/

### colors


green #4Ab29C
grey #555
blue-pin #0077BA
