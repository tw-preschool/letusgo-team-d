class CreateUsers < ActiveRecord::Migration
    def change
        create_table :users do |t|
            t.string :name, :login_name, :password, :address, :telephone
            t.timestamps
        end
    end
end
