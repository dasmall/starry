class TwitterSyncWorker
  include Sidekiq::Worker

  def perform(user_id, import_type)
    @user = User.find user_id
    last_id = nil
    favorites = []

    # Grab up to most recent 1000 favorites
    # for i in 0..15
    15.times do |i|
      search_options = setup_search_params(import_type, last_id)
      results = twitter_client.favorites(search_options)
      new_favorites = get_new_favorites(results)
      favorites.concat new_favorites

      # Duplicate favorites returned / No favorites returned.
      # No need to request more.

      break if results.empty? or (new_favorites.length < results.length)

      last_id = results.last.id
    end

    # Reverse order for most recent tweet to be stored last
    # to keep order in which it was given via API
    favorites = favorites.reverse
    favorites.each do |favorite_data|
      @user.create_new_favorite favorite_data
    end
  end

  def delete(user_id, tweet_id)
    @user = User.find user_id
    @favorite_tweet = FavoriteTweet.find(tweet_id)
    twitter_client.unfavorite([@favorite_tweet.status_id.to_i])
  end

  private

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = @user.access_token
      config.access_token_secret = @user.access_token_secret
    end
  end

  def setup_search_params(import_type, last_id_imported=nil)
    search_options = {
      count: TWITTER_RESULT_COUNT
    }
    case import_type
    when 'import'
      if last_id_imported.nil?
        # queries with max_id return tweets up to
        # max_id including the max_id tweet.
        # subtract 1 to exclude max_id tweet.
        earliest_fave = @user.favorite_tweets.oldest.first
        if earliest_fave
          last_id_imported = earliest_fave.status_id.to_i - 1
          search_options[:max_id] = last_id_imported
        end
      else
        search_options[:max_id] = last_id_imported - 1
      end

    when 'update'
      if not last_id_imported.nil?
        # queries with max_id return tweets up to
        # max_id including the max_id tweet.
        # subtract 1 to exclude max_id tweet.
        search_options[:max_id] = last_id_imported - 1
      else
        # Doesn't work for favorited tweets created prior to since_id
        last_fave = @user.favorite_tweets.recent.first
        if last_fave
          last_id_imported = last_fave.status_id.to_i
          search_options[:since_id] = last_id_imported
        end
      end
    end

    search_options
  end

  def get_new_favorites(favorites)
    favorites.each_with_index do |fave, i|
      existing_favorite = @user.favorite_tweets.find_by status_id: fave.id
      if existing_favorite
        # Return only array of new favorites.
        return new_favorites = favorites.slice(0, i)
        break
      end
    end
    return favorites
  end
end
