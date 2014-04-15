class FavoriteTweetsController < ApplicationController
  before_action :set_favorite_tweet, only: [:show, :edit, :update, :destroy]

  # GET /favorite_tweets
  # GET /favorite_tweets.json
  def index
    @favorite_tweets = FavoriteTweet.where(:user => session[:user_id])
  end

  # GET /favorite_tweets/1
  # GET /favorite_tweets/1.json
  def show
  end

  # GET /favorite_tweets/new
  def new
    @favorite_tweet = FavoriteTweet.new
  end

  # GET /favorite_tweets/1/edit
  def edit
  end

  # POST /favorite_tweets
  # POST /favorite_tweets.json
  def create
    @favorite_tweet = FavoriteTweet.new(favorite_tweet_params)

    respond_to do |format|
      if @favorite_tweet.save
        format.html { redirect_to @favorite_tweet, notice: 'Favorite tweet was successfully created.' }
        format.json { render action: 'show', status: :created, location: @favorite_tweet }
      else
        format.html { render action: 'new' }
        format.json { render json: @favorite_tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /favorite_tweets/1
  # PATCH/PUT /favorite_tweets/1.json
  def update
    respond_to do |format|
      if @favorite_tweet.update(favorite_tweet_params)
        format.html { redirect_to @favorite_tweet, notice: 'Favorite tweet was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @favorite_tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favorite_tweets/1
  # DELETE /favorite_tweets/1.json
  def destroy
    client = setup_twitter_client
    result = client.unfavorite([@favorite_tweet.status_id.to_i])
    @favorite_tweet.destroy
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite_tweet
      @favorite_tweet = FavoriteTweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favorite_tweet_params
      params[:favorite_tweet]
    end
end
