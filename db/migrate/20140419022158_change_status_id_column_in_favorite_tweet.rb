class ChangeStatusIdColumnInFavoriteTweet < ActiveRecord::Migration
  def change
    remove_column :favorite_tweets, :status_id, :integer
    add_column :favorite_tweets, :status_id, :integer, limit: 8
  end
end
