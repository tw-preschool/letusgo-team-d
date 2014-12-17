class CreateUsers < ActiveRecord::Migration
    def change
        create_table :users do |t|
            t.string :username, :name, :password_hash, :address, :telephone
            t.timestamps
        end
    end
end
