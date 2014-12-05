require 'active_record'

class Product < ActiveRecord::Base
	attr_accessor :kindred_price, :amount, :discount_amount

	validates :name, :price, presence: true
	validates :name, length: { maximum: 128 }
	validates :price, numericality: true
end
