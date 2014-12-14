require 'active_record'

class Order < ActiveRecord::Base
    has_and_belongs_to_many :cart_items
end