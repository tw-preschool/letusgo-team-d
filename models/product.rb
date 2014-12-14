require 'active_record'

class Product < ActiveRecord::Base
    has_many :cart_items

	attr_accessor :kindred_price, :amount, :discount_amount

	validates :name, :price, :unit, :quantity, presence: true
	validates :name, length: { maximum: 128 }
	validates :price, numericality: true
end
