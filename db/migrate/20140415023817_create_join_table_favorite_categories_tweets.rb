class CreateJoinTableFavoriteCategoriesTweets < ActiveRecord::Migration
  def change
    create_join_table :favorite_categories, :favorite_tweets do |t|
      # t.index [:favorite_category_id, :favorite_tweet_id]
      # t.index [:favorite_tweet_id, :favorite_category_id]
    end
  end
end
