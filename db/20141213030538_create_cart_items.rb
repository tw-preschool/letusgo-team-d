class CreateCartItems < ActiveRecord::Migration
    def change
        create_table :cart_items do |t|
            t.integer :product_id
            t.float :amount, :default => 1

            t.timestamps 
        end
    end
end