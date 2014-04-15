class FavoriteCategory < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :favorite_tweets, join_table: :favorite_categories_favorite_tweets
end
