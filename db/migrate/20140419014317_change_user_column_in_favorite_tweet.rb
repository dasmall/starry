class ChangeUserColumnInFavoriteTweet < ActiveRecord::Migration
  def change
    rename_column :favorite_tweets, :user, :user_id
  end
end
