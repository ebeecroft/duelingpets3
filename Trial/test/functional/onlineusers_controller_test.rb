require 'test_helper'

class OnlineusersControllerTest < ActionController::TestCase
  setup do
    @onlineuser = onlineusers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:onlineusers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create onlineuser" do
    assert_difference('Onlineuser.count') do
      post :create, onlineuser: { last_visited: @onlineuser.last_visited, signed_in_at: @onlineuser.signed_in_at, signed_out_at: @onlineuser.signed_out_at, user_id: @onlineuser.user_id }
    end

    assert_redirected_to onlineuser_path(assigns(:onlineuser))
  end

  test "should show onlineuser" do
    get :show, id: @onlineuser
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @onlineuser
    assert_response :success
  end

  test "should update onlineuser" do
    put :update, id: @onlineuser, onlineuser: { last_visited: @onlineuser.last_visited, signed_in_at: @onlineuser.signed_in_at, signed_out_at: @onlineuser.signed_out_at, user_id: @onlineuser.user_id }
    assert_redirected_to onlineuser_path(assigns(:onlineuser))
  end

  test "should destroy onlineuser" do
    assert_difference('Onlineuser.count', -1) do
      delete :destroy, id: @onlineuser
    end

    assert_redirected_to onlineusers_path
  end
end
