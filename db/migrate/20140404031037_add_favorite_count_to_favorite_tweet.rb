class AddFavoriteCountToFavoriteTweet < ActiveRecord::Migration
  def change
    add_column :favorite_tweets, :favorite_count, :integer
  end
end
