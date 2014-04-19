class ChangeStatusIdColumnInFavoriteTweet < ActiveRecord::Migration
  def change
    remove_column :favorite_tweets, :status_id
    add_column :favorite_tweets, :status_id, :integer
  end
end
