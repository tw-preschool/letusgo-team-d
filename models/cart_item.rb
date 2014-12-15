require 'active_record'

class CartItem < ActiveRecord::Base
    belongs_to :product
    has_and_belongs_to_many :orders

    def after_save
        self.product.quantity -= self.amount
        self.product.save
    end

    def before_destory
        self.product.quantity += self.amount
        self.product.save
    end
end