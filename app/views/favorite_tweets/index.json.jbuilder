json.array!(@favorite_tweets) do |favorite_tweet|
  json.extract! favorite_tweet, :id
  json.url favorite_tweet_url(favorite_tweet, format: :json)
end
