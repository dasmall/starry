class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :username
      t.string :profile_photo
      t.string :access_token
      t.string :access_token_secret

      t.timestamps
    end
    add_index :users, :uid, unique: true
  end
end
