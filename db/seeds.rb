# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.destroy_all
Project.destroy_all
Worklog.destroy_all

User.create!([
  {
    first_name: "admin",
    last_name: "dude",
    email: "admin@loggylou.com",
    password: "admin",
    password_confirmation: "admin",
    admin: true
  },
  {
    first_name: "Lou",
    last_name: "Cat",
    email: "cat@loggylou.com",
    password: "qwerty",
    password_confirmation: "qwerty"
  },
  {
    first_name: "Test",
    last_name: "Tester",
    email: "test@loggylou.com",
    password: "qwerty",
    password_confirmation: "qwerty"
  }
])

Project.create!([
  {
    name: "Default",
    company: "OkayQuai"
  },
  {
    name: "Test",
    company: "Test"
  },
  {
    name: "Work",
    company: "Work ltd"
  }
])
