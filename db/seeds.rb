# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


users = User.create([{ 
    first_name: "John",
    last_name:  "Doe",
    username: "Superbad",
    password: "123456",
    password_confirmation: "123456",
    email: "Superbad1@email.com",
    status: "new",
    ip: ""},
   { 
    first_name: "John",
    last_name:  "Doe",
    username: "Superbad2",
    password: "123456",
    password_confirmation: "123456",
    email: "Superbad2@email.com",
    status: "new",
    ip: ""}])


