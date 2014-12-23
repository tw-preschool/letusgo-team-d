require 'active_record'
require 'bcrypt'

class User < ActiveRecord::Base

  has_secure_password
  has_many  :orders
  validates :username, uniqueness: { case_sensitive: false}, presence: true

  def self.authenticate(username, password)
    return User.find_by(username:username).try(:authenticate,password)
  end

end
