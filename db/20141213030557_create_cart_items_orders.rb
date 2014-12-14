class CreateCartItemsOrders < ActiveRecord::Migration
    def change
        create_table :cart_items_orders, :id => false do |t|
            t.integer :order_id
            t.integer :cart_item_id

            t.timestamps 
        end
    end
end