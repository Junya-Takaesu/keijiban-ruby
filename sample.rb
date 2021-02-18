# More details about how to use bcrypt
# https://github.com/codahale/bcrypt-ruby#how-to-use-bcrypt-ruby-in-general
# Examples
# https://coderwall.com/p/sjegjq/use-bcrypt-for-passwords
require "bcrypt"

# Generate password
user_provided_password_original = "test"
puts "=== Password is provided by the user: ==="
puts user_provided_password_original
password = BCrypt::Password.create user_provided_password_original
storable_password = password.to_s

# Validate password
user_provided_password_wrong = "cats"
user_provided_password_correct = "test"
restored_password = BCrypt::Password.new storable_password
puts "=== Wrong password is entered: #{user_provided_password_wrong} ==="
puts restored_password == user_provided_password_wrong
puts "=== Correct password is entered: #{user_provided_password_correct} ==="
puts restored_password == user_provided_password_correct