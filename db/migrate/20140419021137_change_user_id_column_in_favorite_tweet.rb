class ChangeUserIdColumnInFavoriteTweet < ActiveRecord::Migration
  def change
    change_column :favorite_tweets, :user_id, :integer
  end
end
