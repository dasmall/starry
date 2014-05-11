class TagsController < ApplicationController
  def index
  end

  def create
    fave = FavoriteTweet.find params[:favorite_tweet_id]
    fave.tags_list = params[:tag][:name]
    fave.save validate: false
    # binding.pry
  end
end
