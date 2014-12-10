class QuantityProducts < ActiveRecord::Migration
    def change
        change_table :products do |t|
            t.integer :quantity
        end
    end
end
