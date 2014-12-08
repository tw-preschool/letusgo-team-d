class DescriptionProducts < ActiveRecord::Migration
    def change
        change_table :products do |t|
            t.string :description
        end
    end
end