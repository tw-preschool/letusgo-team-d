require 'active_record'

class Order < ActiveRecord::Base
    has_and_belongs_to_many :cart_items

    def init_by shopping_cart
        shopping_cart.shopping_list.each do |item|
            self.cart_items.create(product_id: item.id, amount: item.amount)
        end
        self.sum = shopping_cart.sum_price
        self.discount = shopping_cart.sum_discount
        self.time = DateTime.now
        self.number = "#{DateTime.now.to_i}#{self.id}"
        self.save
    end
end