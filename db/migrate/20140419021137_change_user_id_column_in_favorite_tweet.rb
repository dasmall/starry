class ChangeUserIdColumnInFavoriteTweet < ActiveRecord::Migration
  def change
    remove_column :favorite_tweets, :user_id
    add_column :favorite_tweets, :user_id, :integer
  end
end
