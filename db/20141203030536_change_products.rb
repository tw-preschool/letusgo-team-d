class ChangeProducts < ActiveRecord::Migration
    def change
        change_table :products do |t|
            t.boolean :is_promotional
        end
    end
end