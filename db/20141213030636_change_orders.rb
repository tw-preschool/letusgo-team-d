class ChangeOrders < ActiveRecord::Migration
    def change
        change_table :orders do |t|
            t.string :number
            t.float :sum, default: 0.0
            t.float :discount, default: 0.0
            t.datetime :time, default: DateTime.now
        end
    end
end