require 'test_helper'

class StarryControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get signin" do
    get :signin
    assert_response :success
  end

  test "should get signout" do
    get :signout
    assert_response :success
  end

end
