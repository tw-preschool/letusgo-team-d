#encoding=UTF-8
require 'active_record'

class Product < ActiveRecord::Base
    has_many :cart_items

	attr_accessor :kindred_price, :amount, :discount_amount

	validates :name, :price, :unit, :quantity, presence: true
	validates :name, length: { maximum: 128 }
	validates :price, numericality: true

    def reduce_quantity amount = 1
        self.quantity -= amount
        self.save
        raise RangeError, "提交失败！商品 [#{self.name}] 的库存不足，\
        请检查后重试！" if self.quantity < 0
    end

    def increase_quantity amount = 1
        self.quantity += amount
        self.save
    end
end
