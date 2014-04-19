class FavoriteTweet < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :status_id
  has_and_belongs_to_many :favorite_categories, join_table: :favorite_categories_favorite_tweets

  def self.create_new_favorite(tweet_data, user_id)
    @favorite = FavoriteTweet.new(
      :text => tweet_data.text,
      :status_id => tweet_data.id,
      :favorite_count => tweet_data.favorite_count,
      :date_posted => tweet_data.created_at,
      :user => user_id,
      :raw_data => tweet_data.to_json
    )
    @favorite.save
    @favorite
  end
  def self.random_favorites(user_id, count=3)
    FavoriteTweet.limit(count).order('RANDOM()').where(:user => user_id)
  end
end
