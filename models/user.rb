require 'active_record'

class User < ActiveRecord::Base
   attr_accessor :login_name, :password, :name, :address, :telephone
   validates :login_name, uniqueness: { case_sensitive: false}
end
