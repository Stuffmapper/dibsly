== README

#TODO
	SET UP MESSAGING USING MAILBOXER
#TODO
	SETUP OMNIAUTH FOR ALL USERS

#TODO

	SWITCH OVER TO AMAZON - CREATE SANDBOX FOR DEVELOPMENT?
#TODO
	VCR FOR TESTING?

switch from jbuilder to active record serializers




## Setting up a StuffMapper workspace:
### Prerequisites:
'''
$ sudo yum install gcc gcc-c++ git

$ sudo yum install ruby

$ sudo yum install ruby-devel

$ sudo yum install postgresql

$ sudo yum install postgresql-server

$ sudo yum install postgresql-devel

$ sudo yum install mysql-devel

$ sudo yum install sqlite3x-devel

$ sudo yum install libyaml-devel

$ sudo yum instal nodejs

$ sudo gem update 

$ sudo gem update  --system

$ sudo gem install rails

$ sudo gem install sqlite3-ruby

$ sudo gem install pg

$ sudo gem install phantomjs-binaries
'''
### Forking dibsly:
*Navigate to the directory you want to fork the repo*
'''
$ gem install rdoc-data

$ rdoc-data --install

$ sudo gem pristine --all

$ su

$ bundle install
'''

### Postgres installation:
'''
$ sudo -u postgres psql      *# Postgres terminal*

postgres=# \password         *# Prompts you for psql password*

postgres=# create user "<**username**>" with password '<**password**>';

postgres=# alter user <**username**> superuser;

postgres=# create database "dibsley_development";

postgres=# create database "dibsley_test";

postgres=# grant all privileges on database dibsley_development to <username>;

postgres=# grant all privileges on database dibsley_test to <username>;
'''

*Ctrl+D to exit postgres command line*

'''
$ bundle exec rake db:migrate

$ bundle exec rake db:create

$ rake db:migrate RAILS_ENV=development

'''
### Starting rails:
'''
$rails s
'''

*Should be able to view it at localhost:3000*


This uses bower to install

 	rake bower:install

To get angular and rails working on the site, the instructions on [angular-rails.com](http://www.angular-rails.com) were strictly followed. Some things will be implemented the slightly different . But is should be a good read through to understand why this site was set up the way it was.



This uses, angular.js and bootstrap on the front end.  And used bower to handle the package management. The angular code is written

Postgres should be installed

angular specs are written in 


run angular front end test
	rake teaspoon

Cucumber test 
	cucumber
Rspec tests 
	rspec



Rails s



user.maps << map




* Environment setup



