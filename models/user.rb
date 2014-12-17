require 'active_record'
require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  validates :username, uniqueness: { case_sensitive: false}

  attr_writer :confirm_password

  def self.authenticate(username, password)
    user = self.find_by_username(username)
    return nil if user.nil?

    user.password == password ? user : nil
  end

  def password
      @password ||= Password.new(password_hash)
  end

  def password=(new_password)
      @password = Password.create(new_password)
      self.password_hash = @password
  end

end
