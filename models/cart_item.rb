require 'active_record'

class CartItem < ActiveRecord::Base
    belongs_to :product
    has_and_belongs_to_many :orders

    def after_save
        self.product.reduce_quantity self.amount
    end

    def before_destory
        self.product.increase_quantity self.amount
    end

    def destory
        before_destory
        self.delete
    end
end