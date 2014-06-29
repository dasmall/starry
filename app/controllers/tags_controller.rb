class TagsController < ApplicationController
  def index
  end

  def create
    fave = FavoriteTweet.find params[:favorite_tweet_id]
    fave.category_list.add params[:tag][:name]
    fave.save validate: false
  end
end
