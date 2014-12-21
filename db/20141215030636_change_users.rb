class ChangeUsers < ActiveRecord::Migration
    def change
        change_table :users do |t|
            t.text :cart_data
        end
    end
end