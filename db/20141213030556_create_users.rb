class CreateUsers < ActiveRecord::Migration
    def change
        create_table :users do |t|
            t.string :login_name, :name, :password, :address, :telephone
            t.timestamps
        end
    end
end
