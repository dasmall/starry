class FavoriteTweet < ActiveRecord::Base
  validates_uniqueness_of :status_id
  def self.create_new_favorite(tweet_data, user_id)
    @favorite = FavoriteTweet.new(
      :text => tweet_data.text,
      :status_id => tweet_data.id,
      :date_posted => tweet_data.created_at,
      :user => user_id,
      :raw_data => tweet_data.to_json
    )
    @favorite.save
    @favorite
  end
end
