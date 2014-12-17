class CreateUsers < ActiveRecord::Migration
    def change
        create_table :users do |t|
            t.string :username, :name, :password, :password_digest, :password_comfirmation, :address, :telephone
            t.timestamps
        end
    end
end
