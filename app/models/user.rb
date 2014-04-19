class User < ActiveRecord::Base
  has_many :favorite_tweets, dependent: :destroy

  def self.create_new_user(auth_data)
    @user = User.new(
      :uid => auth_data.uid,
      :username => auth_data.info.nickname,
      :profile_photo => auth_data.info.image,
      :access_token => auth_data.credentials.token,
      :access_token_secret => auth_data.credentials.secret
    )
    @user.save
    @user
  end

  def create_new_favorite(tweet)
    FavoriteTweet.create_new_favorite tweet, id
  end

  def random_favorites(count=3)
    favorite_tweets.order('RANDOM()').limit count
  end
end
