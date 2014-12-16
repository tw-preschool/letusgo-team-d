require 'active_record'

class User < ActiveRecord::Base
  validates :login_name, uniqueness: { case_sensitive: false}   
end
