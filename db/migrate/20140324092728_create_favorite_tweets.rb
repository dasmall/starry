class CreateFavoriteTweets < ActiveRecord::Migration
  def change
    create_table :favorite_tweets do |t|
      t.text :text
      t.string :status_id
      t.datetime :date_posted
      t.string :user
      t.text :raw_data

      t.timestamps
    end
  end
end
