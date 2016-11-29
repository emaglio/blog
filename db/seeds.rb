# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


admin = User::Create.(firstname: "Admin", 
                      lastname: "Imp", 
                      email: "admin@email.com",
                      phone: "0123456789", 
                      gender: "Male",
                      age: 30, 
                      password: "Test1234", 
                      confirm_password: "Test1234").model