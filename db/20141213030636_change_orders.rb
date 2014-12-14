class ChangeOrders < ActiveRecord::Migration
    def change
        change_table :orders do |t|
            t.string :number
            t.float :sum
            t.float :discount
            t.datetime :time
        end
    end
end