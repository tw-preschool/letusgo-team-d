require 'active_record'

class CartItem < ActiveRecord::Base
    belongs_to :product
    has_and_belongs_to_many :orders
end