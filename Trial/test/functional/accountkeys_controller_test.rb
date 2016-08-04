require 'test_helper'

class AccountkeysControllerTest < ActionController::TestCase
  setup do
    @accountkey = accountkeys(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accountkeys)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create accountkey" do
    assert_difference('Accountkey.count') do
      post :create, accountkey: { activated: @accountkey.activated, token: @accountkey.token, user_id: @accountkey.user_id }
    end

    assert_redirected_to accountkey_path(assigns(:accountkey))
  end

  test "should show accountkey" do
    get :show, id: @accountkey
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @accountkey
    assert_response :success
  end

  test "should update accountkey" do
    put :update, id: @accountkey, accountkey: { activated: @accountkey.activated, token: @accountkey.token, user_id: @accountkey.user_id }
    assert_redirected_to accountkey_path(assigns(:accountkey))
  end

  test "should destroy accountkey" do
    assert_difference('Accountkey.count', -1) do
      delete :destroy, id: @accountkey
    end

    assert_redirected_to accountkeys_path
  end
end
