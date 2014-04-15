require 'test_helper'

class FavoriteTweetsControllerTest < ActionController::TestCase
  setup do
    @favorite_tweet = favorite_tweets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:favorite_tweets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create favorite_tweet" do
    assert_difference('FavoriteTweet.count') do
      post :create, favorite_tweet: {  }
    end

    assert_redirected_to favorite_tweet_path(assigns(:favorite_tweet))
  end

  test "should show favorite_tweet" do
    get :show, id: @favorite_tweet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @favorite_tweet
    assert_response :success
  end

  test "should update favorite_tweet" do
    patch :update, id: @favorite_tweet, favorite_tweet: {  }
    assert_redirected_to favorite_tweet_path(assigns(:favorite_tweet))
  end

  test "should destroy favorite_tweet" do
    assert_difference('FavoriteTweet.count', -1) do
      delete :destroy, id: @favorite_tweet
    end

    assert_redirected_to favorite_tweets_path
  end
end
