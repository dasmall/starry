class StarryController < ApplicationController
  before_action :require_session
  skip_before_action :require_session, only: [:index]

  def index
    if session[:user_id]
      @user = User.find_by id: session[:user_id]
      @random_favorites = @user.random_favorites
    end
  end

  def get_faves
    # @user = User.find_by id: session[:user_id]
    TwitterSyncWorker.new.perform(@user.id, params[:import_type])

    redirect_to action: 'show_faves'
  end

  def uncategorized_faves
    @faves = get_tweets_without_categories false
  end

  def get_category_faves
    puts params[:category]
    @faves = @user.favorite_tweets.tagged_with(params[:category])
  end    

  def show_faves
    # if session[:user_id]
    #   @user = User.find_by id: session[:user_id]
    # end
    @faves_without_categories = get_tweets_without_categories
    @categories = get_category_tweets
  end
  
  private
    def get_tweets_without_categories(n=15)
      faves_without_categories = []
      @user.favorite_tweets.recent.each_with_index do |fave, i|
        if n and faves_without_categories.length >= n
          break
        end

        if fave.category.empty?
          faves_without_categories.push fave
        end
      end
      return faves_without_categories
    end

    def get_category_tweets(n=5)
      categories = []
      @category_list = @user.favorite_tweets.category_counts.sort! { |cat1, cat2| cat1.name <=> cat2.name }

      @category_list.each_with_index do |category, i|
        if i>=n and n
          break
        end
        tweets = @user.favorite_tweets.tagged_with(category.name)
        categories << {:name => category.name, :tweets => tweets}
      end

      return categories
    end
end
