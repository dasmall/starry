class TagsController < ApplicationController
  def index
  end

  def create
    action = "create"
    fave = FavoriteTweet.find params[:favorite_tweet_id]
    categories = fave.category_list.add params[:category][:name]
    fave.save validate: false
    category = ActsAsTaggableOn::Tag.find_by(:name => categories.last)

    respond_to do |format|
      format.json { render :json =>
        {
          :action => action,
          :category => category,
          :favorite_tweet_id => params[:favorite_tweet_id]
        } 
      }
    end

  end

  def update
    action = 'update'
    fave = FavoriteTweet.find params[:favorite_tweet_id]
    category = params[:category]

    if fave.category_list.include? category[:name]
      fave.category_list.remove category[:name]
    elsif
      fave.category_list.add category[:name] 
    end

    fave.save validate: false

    respond_to do |format|
      format.json { render :json =>
        {
          :action => action,
          :category => category,
          :favorite_tweet_id => params[:favorite_tweet_id]
        } 
      }
    end
  end
end
