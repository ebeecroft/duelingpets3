require 'test_helper'

class SessionkeysControllerTest < ActionController::TestCase
  setup do
    @sessionkey = sessionkeys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sessionkeys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sessionkey" do
    assert_difference('Sessionkey.count') do
      post :create, sessionkey: { expiretime: @sessionkey.expiretime, remember_token: @sessionkey.remember_token, user_id: @sessionkey.user_id }
    end

    assert_redirected_to sessionkey_path(assigns(:sessionkey))
  end

  test "should show sessionkey" do
    get :show, id: @sessionkey
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sessionkey
    assert_response :success
  end

  test "should update sessionkey" do
    put :update, id: @sessionkey, sessionkey: { expiretime: @sessionkey.expiretime, remember_token: @sessionkey.remember_token, user_id: @sessionkey.user_id }
    assert_redirected_to sessionkey_path(assigns(:sessionkey))
  end

  test "should destroy sessionkey" do
    assert_difference('Sessionkey.count', -1) do
      delete :destroy, id: @sessionkey
    end

    assert_redirected_to sessionkeys_path
  end
end
